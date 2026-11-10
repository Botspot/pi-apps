#!/usr/bin/env python3
import ftplib
import os
import posixpath
import queue
import shutil
import stat
import subprocess
import sys
import threading
from urllib.parse import urlsplit

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk, GLib, Gtk, Pango


def safe_name(name):
    if (not name or name in (".", "..") or "/" in name or "\\" in name
            or any(ord(char) < 32 or ord(char) == 127 for char in name)):
        raise ValueError("Geçersiz dosya veya klasör adı.")
    return name


class Connection:
    """Yalnızca iş parçacığından kullanılan FTP/SFTP bağlantısı."""

    def __init__(self):
        self.ftp = None
        self.ssh = None
        self.sftp = None

    def connect(self, host, username, password, port):
        self.close()
        address = urlsplit(host if "://" in host else "ftp://" + host)
        if (address.scheme not in ("ftp", "sftp") or not address.hostname
                or address.username is not None or address.password is not None
                or address.path not in ("", "/") or address.query or address.fragment):
            raise ValueError("Sunucu için ftp://sunucu veya sftp://sunucu kullanın.")
        port = address.port or int(port)
        if not 1 <= port <= 65535:
            raise ValueError("Port 1 ile 65535 arasında olmalıdır.")
        try:
            if address.scheme == "sftp":
                try:
                    import paramiko
                except ImportError:
                    raise RuntimeError("SFTP için Paramiko kurulmalıdır; README dosyasına bakın.") from None
                self.ssh = paramiko.SSHClient()
                self.ssh.load_system_host_keys()
                if os.path.isfile("/etc/ssh/ssh_known_hosts"):
                    self.ssh.load_system_host_keys("/etc/ssh/ssh_known_hosts")
                self.ssh.set_missing_host_key_policy(paramiko.RejectPolicy())
                self.ssh.connect(address.hostname, port=port, username=username,
                                 timeout=20, auth_timeout=20, banner_timeout=20,
                                 look_for_keys=False, allow_agent=False,
                                 **{"password": password})
                self.sftp = self.ssh.open_sftp()
                self.sftp.get_channel().settimeout(30)
                return self.sftp.normalize(".")
            self.ftp = ftplib.FTP()
            self.ftp.connect(address.hostname, port, timeout=30)
            self.ftp.login(username, password)
            return self.ftp.pwd()
        except Exception:
            self.close()
            raise

    def close(self):
        for resource in (self.sftp, self.ssh, self.ftp):
            if resource is not None:
                try:
                    resource.close()
                except Exception:
                    pass
        self.sftp = self.ssh = self.ftp = None

    def listing(self, path):
        if self.sftp:
            return [(safe_name(item.filename), stat.S_ISDIR(item.st_mode), item.st_size)
                    for item in self.sftp.listdir_attr(path)
                    if item.filename not in (".", "..")]
        self.ftp.cwd(path)
        try:
            return [(safe_name(name), facts.get("type") == "dir",
                     int(facts.get("size", 0)))
                    for name, facts in self.ftp.mlsd()
                    if name not in (".", "..") and facts.get("type") not in ("cdir", "pdir")]
        except ftplib.error_perm as error:
            if str(error)[:3] not in ("500", "501", "502", "504"):
                raise
        result = []
        current = self.ftp.pwd()
        for entry in self.ftp.nlst():
            name = posixpath.basename(entry.rstrip("/"))
            if name in (".", ".."):
                continue
            safe_name(name)
            try:
                self.ftp.cwd(posixpath.join(current, name))
            except ftplib.error_perm:
                is_dir = False
            else:
                is_dir = True
                self.ftp.cwd(current)
            result.append((name, is_dir, 0))
        return result

    def upload(self, local, remote_dir, name):
        safe_name(name)
        if any(item[0] == name for item in self.listing(remote_dir)):
            raise FileExistsError("Uzak hedef zaten var; önce yeniden adlandırın veya silin.")
        remote = posixpath.join(remote_dir, name)
        with open(local, "rb") as source:
            if self.sftp:
                with self.sftp.open(remote, "wx") as target:
                    shutil.copyfileobj(source, target)
            else:
                self.ftp.storbinary("STOR " + remote, source)

    def download(self, remote_dir, name, local_dir):
        safe_name(name)
        remote = posixpath.join(remote_dir, name)
        local = os.path.join(local_dir, name)
        with open(local, "xb") as target:
            try:
                if self.sftp:
                    with self.sftp.open(remote, "rb") as source:
                        shutil.copyfileobj(source, target)
                else:
                    self.ftp.retrbinary("RETR " + remote, target.write)
            except Exception:
                os.unlink(local)
                raise

    def mkdir(self, parent, name):
        path = posixpath.join(parent, safe_name(name))
        if self.sftp:
            self.sftp.mkdir(path)
        else:
            self.ftp.mkd(path)

    def delete(self, parent, name, is_dir):
        path = posixpath.join(parent, safe_name(name))
        if self.sftp:
            (self.sftp.rmdir if is_dir else self.sftp.remove)(path)
        else:
            (self.ftp.rmd if is_dir else self.ftp.delete)(path)


def accessible(widget, name, description):
    obj = widget.get_accessible()
    obj.set_name(name)
    obj.set_description(description)
    return widget


class RaspiFTP(Gtk.Window):
    def __init__(self):
        super().__init__(title="raspiFTP — FTP/SFTP İstemcisi")
        self.set_default_size(1100, 650)
        accessible(self, "raspiFTP", "Klavye ve Orca ile kullanılabilen çift panelli FTP/SFTP istemcisi.")
        self.connection = Connection()
        self.jobs = queue.Queue()
        self.busy = False
        self.connected = False
        self.closed = False
        self.active = "local"
        self.local_dir = os.path.expanduser("~")
        self.remote_dir = "/"
        self.speech = queue.Queue()
        threading.Thread(target=self.worker, daemon=True).start()
        threading.Thread(target=self.speaker, daemon=True).start()
        self.connect("delete-event", self.on_close)
        self.connect("key-press-event", self.on_key)

        root = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8, margin=10)
        self.add(root)
        bar = Gtk.Grid(column_spacing=8, row_spacing=4)
        root.pack_start(bar, False, False, 0)
        self.entries = {}
        for column, (key, label, name, text, description) in enumerate((
                ("host", "_Sunucu:", "Sunucu", "", "FTP sunucu adı veya sftp://sunucu. Alt+S."),
                ("username", "Kullanıcı Adı (_U):", "Kullanıcı adı", "", "Sunucu kullanıcı adınız."),
                ("password", "_Parola:", "Parola", "", "Parola gizlenir ve kaydedilmez."),
                ("port", "P_ort:", "Port", "21", "FTP için 21, SFTP için genellikle 22."))):
            entry = accessible(Gtk.Entry(), name, description)
            entry.set_text(text)
            entry.set_hexpand(key != "port")
            if key == "port":
                entry.set_width_chars(6)
                entry.set_input_purpose(Gtk.InputPurpose.DIGITS)
            if key == "password":
                entry.set_visibility(False)
                entry.set_input_purpose(Gtk.InputPurpose.PASSWORD)
            label_widget = Gtk.Label.new_with_mnemonic(label)
            label_widget.set_mnemonic_widget(entry)
            label_widget.set_xalign(0)
            bar.attach(label_widget, column, 0, 1, 1)
            bar.attach(entry, column, 1, 1, 1)
            entry.connect("activate", self.connect_server)
            self.entries[key] = entry
        self.entries["host"].connect("changed", self.host_changed)
        self.connect_button = self.button("Hızlı _Bağlan", "Hızlı bağlan",
                                          "Sunucuya bağlan. Alt+B.", self.connect_server)
        self.disconnect_button = self.button("Bağlantıyı Kes (_D)", "Bağlantıyı kes",
                                             "Sunucu bağlantısını kapat.", self.disconnect_server)
        bar.attach(self.connect_button, 4, 1, 1, 1)
        bar.attach(self.disconnect_button, 5, 1, 1, 1)

        panels = accessible(Gtk.Paned.new(Gtk.Orientation.HORIZONTAL), "Dosya panelleri",
                            "Yerel ve uzak dosya panelleri. F6 ile panel değiştirin.")
        panels.set_wide_handle(True)
        root.pack_start(panels, True, True, 0)
        self.views = {}
        self.models = {}
        self.paths = {}
        for side, title in (("local", "Yerel Bilgisayar"), ("remote", "Uzak Sunucu")):
            box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=4)
            heading = Gtk.Label(label=title, xalign=0)
            box.pack_start(heading, False, False, 0)
            path = accessible(Gtk.Entry(), title + " dizini", "Geçerli dizinin salt okunur yolu.")
            path.set_editable(False)
            heading.set_mnemonic_widget(path)
            path.connect("focus-in-event", self.focus_panel, side)
            box.pack_start(path, False, False, 0)
            model = Gtk.ListStore(str, str, str, bool)
            tree = accessible(Gtk.TreeView(model=model), title + " dosyaları",
                              "Ok tuşlarıyla seçin. Enter ile klasöre girin. İki nokta üst dizindir.")
            tree.get_selection().set_mode(Gtk.SelectionMode.SINGLE)
            tree.connect("focus-in-event", self.focus_panel, side)
            tree.connect("row-activated", self.activate_row, side)
            for index, title_text in enumerate(("Dosya Adı", "Tür", "Boyut (bayt)")):
                renderer = Gtk.CellRendererText()
                if index == 0:
                    renderer.set_property("ellipsize", Pango.EllipsizeMode.MIDDLE)
                col = Gtk.TreeViewColumn(title_text, renderer, text=index)
                col.set_resizable(True)
                col.set_expand(index == 0)
                tree.append_column(col)
            scroll = Gtk.ScrolledWindow()
            scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
            scroll.add(tree)
            box.pack_start(scroll, True, True, 0)
            (panels.pack1 if side == "local" else panels.pack2)(box, True, False)
            self.views[side], self.models[side], self.paths[side] = tree, model, path
        panels.set_position(530)
        actions = Gtk.Box(spacing=8)
        root.pack_start(actions, False, False, 0)
        self.action_buttons = []
        for label, name, description, callback in (
                ("Karşıya _Yükle", "Karşıya yükle", "Seçili yerel dosyayı yükle. Alt+Y.", self.upload),
                ("İndir (_I)", "İndir", "Seçili uzak dosyayı indir. Alt+I.", self.download),
                ("Yenile (_R)", "Yenile", "Her iki paneli yenile. Alt+R veya F5.", self.refresh),
                ("Yeni Klasör (_N)", "Yeni klasör", "Son odaklanılan panelde klasör oluştur.", self.create_folder),
                ("Sil (_L)", "Sil", "Son odaklanılan paneldeki öğeyi onay alarak sil.", self.delete)):
            button = self.button(label, name, description, callback)
            actions.pack_start(button, False, False, 0)
            self.action_buttons.append(button)
        self.status = accessible(Gtk.Statusbar(), "Durum", "İşlem sonuçları Türkçe sesle de bildirilir.")
        root.pack_start(self.status, False, False, 0)
        self.status.push(0, "Hazır. FTP şifrelenmez; güvenli aktarım için SFTP kullanın.")
        self.update_controls()
        self.show_all()
        self.entries["host"].grab_focus()
        self.refresh()

    def button(self, label, name, description, callback):
        button = accessible(Gtk.Button.new_with_mnemonic(label), name, description)
        button.connect("clicked", callback)
        return button

    def host_changed(self, entry):
        self.entries["port"].set_text("22" if entry.get_text().strip().startswith("sftp://") else "21")

    def focus_panel(self, widget, event, side):
        self.active = side
        return False

    def on_key(self, widget, event):
        key = Gdk.keyval_to_lower(event.keyval)
        if key == Gdk.KEY_Escape:
            self.close()
            return True
        if key == Gdk.KEY_F6:
            self.views["remote" if self.active == "local" else "local"].grab_focus()
            return True
        if key == Gdk.KEY_F5:
            self.refresh()
            return True
        if event.state & Gdk.ModifierType.MOD1_MASK:
            if key == Gdk.KEY_s:
                self.entries["host"].grab_focus()
                return True
            action = {Gdk.KEY_b: self.connect_server, Gdk.KEY_y: self.upload,
                      Gdk.KEY_i: self.download, Gdk.KEY_idotless: self.download,
                      Gdk.KEY_r: self.refresh}.get(key)
            if action:
                action()
                return True
        return False

    def notify(self, message):
        if self.closed:
            return
        self.status.pop(0)
        self.status.push(0, message)
        self.status.get_accessible().set_description(message)
        self.speech.put(message)

    def speaker(self):
        while True:
            message = self.speech.get()
            if message is None:
                return
            try:
                subprocess.run(["spd-say", "-l", "tr", "-w", "--", message],
                               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=30)
            except (OSError, subprocess.TimeoutExpired):
                pass

    def worker(self):
        while True:
            job = self.jobs.get()
            if job is None:
                self.connection.close()
                return
            operation, done, message = job
            try:
                result = operation()
            except Exception as error:
                GLib.idle_add(self.finish, None, done, message, error)
            else:
                GLib.idle_add(self.finish, result, done, message, None)

    def submit(self, operation, done=None, message=None, start=None):
        if self.busy or self.closed:
            return
        self.return_focus = self.get_focus()
        self.busy = True
        self.update_controls()
        if start:
            self.notify(start)
        self.jobs.put((operation, done, message))

    def finish(self, result, done, message, error):
        if self.closed:
            return False
        self.busy = False
        self.update_controls()
        if self.return_focus and self.return_focus.get_sensitive():
            self.return_focus.grab_focus()
        if error is not None:
            self.notify("Hata: " + str(error))
        else:
            if message:
                self.notify(message)
            if done:
                done(result)
        return False

    def update_controls(self):
        self.connect_button.set_sensitive(not self.busy and not self.connected)
        self.disconnect_button.set_sensitive(not self.busy and self.connected)
        for entry in self.entries.values():
            entry.set_sensitive(not self.busy and not self.connected)
        for index, button in enumerate(self.action_buttons):
            button.set_sensitive(not self.busy and (self.connected or index >= 2))
        for tree in self.views.values():
            tree.set_sensitive(not self.busy)

    def connect_server(self, *args):
        if self.busy or self.connected:
            return
        values = [self.entries[key].get_text().strip() if key != "password"
                  else self.entries[key].get_text()
                  for key in ("host", "username", "password", "port")]
        if not values[0] or not values[1]:
            self.notify("Hata: Sunucu ve kullanıcı adı gereklidir.")
            return

        def connected(path):
            self.entries["password"].set_text("")
            self.connected = True
            self.remote_dir = path
            self.update_controls()
            self.refresh()

        self.submit(lambda: self.connection.connect(*values), connected,
                    "Bağlantı kuruldu.", "Bağlantı kuruluyor.")

    def disconnect_server(self, *args):
        if self.busy or not self.connected:
            return

        def disconnected(result):
            self.connected = False
            self.models["remote"].clear()
            self.paths["remote"].set_text("")
            self.update_controls()
            self.entries["host"].grab_focus()

        self.submit(self.connection.close, disconnected, "Bağlantı kesildi.")

    def fill_panel(self, side, path, rows):
        model = self.models[side]
        model.clear()
        model.append(["..", "Üst dizin", "", True])
        for name, is_dir, size in sorted(rows, key=lambda row: (not row[1], row[0].casefold())):
            model.append([name, "Klasör" if is_dir else "Dosya", "" if is_dir else str(size), is_dir])
        self.paths[side].set_text(path)
        self.views[side].set_cursor(Gtk.TreePath.new_from_indices([0]))

    def refresh(self, *args):
        if self.busy:
            return
        local, remote, connected = self.local_dir, self.remote_dir, self.connected

        def operation():
            with os.scandir(local) as entries:
                rows = [(entry.name, entry.is_dir(), entry.stat().st_size)
                        for entry in entries if not entry.is_symlink() or os.path.exists(entry.path)]
            remote_rows = self.connection.listing(remote) if connected else []
            return rows, remote_rows

        def refreshed(result):
            self.fill_panel("local", local, result[0])
            if connected:
                self.fill_panel("remote", remote, result[1])

        self.submit(operation, refreshed, "Dosya listeleri yenilendi.")

    def selection(self, side):
        model, iterator = self.views[side].get_selection().get_selected()
        if iterator is None or model[iterator][0] == "..":
            self.notify("Bir dosya veya klasör seçin.")
            return None
        return model[iterator][0], model[iterator][3]

    def activate_row(self, tree, path, column, side):
        if self.busy or (side == "remote" and not self.connected):
            return
        row = self.models[side][path]
        if not row[3]:
            return
        name = row[0]
        if side == "local":
            target = os.path.abspath(os.path.join(self.local_dir, name))

            def operation():
                with os.scandir(target) as entries:
                    return [(entry.name, entry.is_dir(), entry.stat().st_size)
                            for entry in entries if not entry.is_symlink() or os.path.exists(entry.path)]
        else:
            target = posixpath.normpath(posixpath.join(self.remote_dir, name))

            def operation():
                return self.connection.listing(target)

        def navigated(rows):
            if side == "local":
                self.local_dir = target
            else:
                self.remote_dir = target
            self.fill_panel(side, target, rows)
            self.views[side].grab_focus()

        self.submit(operation, navigated, "Dizin açıldı: " + target)

    def upload(self, *args):
        self.transfer("local")

    def download(self, *args):
        self.transfer("remote")

    def transfer(self, side):
        if self.busy:
            return
        if not self.connected:
            self.notify("Önce sunucuya bağlanın.")
            return
        selected = self.selection(side)
        if not selected:
            return
        name, is_dir = selected
        if is_dir:
            self.notify("Aktarım için bir dosya seçin; klasör aktarımı desteklenmiyor.")
            return
        local, remote = self.local_dir, self.remote_dir
        if side == "local":
            operation = lambda: self.connection.upload(os.path.join(local, name), remote, name)
        else:
            operation = lambda: self.connection.download(remote, name, local)
        self.submit(operation, lambda result: self.refresh(),
                    "Dosya aktarımı tamamlandı: " + name, "Dosya aktarımı başladı: " + name)

    def create_folder(self, *args):
        if self.busy:
            return
        side = self.active
        if side == "remote" and not self.connected:
            self.notify("Önce sunucuya bağlanın.")
            return
        dialog = accessible(Gtk.Dialog(title="Yeni Klasör", transient_for=self, modal=True),
                            "Yeni klasör", "Etkin dosya panelinde bir klasör oluşturun.")
        accessible(dialog.add_button("_İptal", Gtk.ResponseType.CANCEL),
                   "İptal", "Klasör oluşturmadan iletişim kutusunu kapat.")
        accessible(dialog.add_button("_Oluştur", Gtk.ResponseType.OK),
                   "Oluştur", "Girilen adla klasör oluştur.")
        entry = accessible(Gtk.Entry(), "Yeni klasör adı", "Yalnızca klasör adını girin; yol girmeyin.")
        label = Gtk.Label.new_with_mnemonic("Klasör _adı:")
        label.set_mnemonic_widget(entry)
        dialog.get_content_area().pack_start(label, False, False, 4)
        dialog.get_content_area().pack_start(entry, False, False, 4)
        dialog.set_default_response(Gtk.ResponseType.OK)
        entry.set_activates_default(True)
        dialog.show_all()
        response = dialog.run()
        name = entry.get_text()
        dialog.destroy()
        if response != Gtk.ResponseType.OK:
            return
        try:
            safe_name(name)
        except ValueError as error:
            self.notify("Hata: " + str(error))
            return
        parent = self.local_dir if side == "local" else self.remote_dir
        operation = (lambda: os.mkdir(os.path.join(parent, name))) if side == "local" else (
            lambda: self.connection.mkdir(parent, name))
        self.submit(operation, lambda result: self.refresh(), "Klasör oluşturuldu: " + name)

    def delete(self, *args):
        if self.busy:
            return
        side = self.active
        if side == "remote" and not self.connected:
            self.notify("Önce sunucuya bağlanın.")
            return
        selected = self.selection(side)
        if not selected:
            return
        name, is_dir = selected
        dialog = Gtk.MessageDialog(transient_for=self, modal=True,
                                   message_type=Gtk.MessageType.WARNING,
                                   buttons=Gtk.ButtonsType.OK_CANCEL,
                                   text="Seçili öğe silinsin mi?")
        dialog.format_secondary_text(name + "\nBu işlem geri alınamaz. Yalnızca boş klasörler silinir.")
        accessible(dialog, "Silme onayı", "Seçili öğeyi kalıcı olarak silmek için onay verin.")
        accessible(dialog.get_widget_for_response(Gtk.ResponseType.OK),
                   "Sil", "Seçili öğeyi kalıcı olarak sil.")
        accessible(dialog.get_widget_for_response(Gtk.ResponseType.CANCEL),
                   "İptal", "Öğeyi silmeden iletişim kutusunu kapat.")
        dialog.set_default_response(Gtk.ResponseType.CANCEL)
        response = dialog.run()
        dialog.destroy()
        if response != Gtk.ResponseType.OK:
            return
        parent = self.local_dir if side == "local" else self.remote_dir

        def operation():
            if side == "remote":
                self.connection.delete(parent, name, is_dir)
            else:
                path = os.path.join(parent, name)
                (os.rmdir if is_dir and not os.path.islink(path) else os.unlink)(path)

        self.submit(operation, lambda result: self.refresh(), "Silindi: " + name)

    def on_close(self, *args):
        self.closed = True
        self.jobs.put(None)
        self.speech.put(None)
        Gtk.main_quit()
        return False


def main():
    if not Gtk.init_check(sys.argv)[0]:
        print("GTK görüntü sunucusu bulunamadı. Masaüstü oturumunda çalıştırın.", file=sys.stderr)
        return 1
    RaspiFTP()
    Gtk.main()
    return 0


if __name__ == "__main__":
    sys.exit(main())

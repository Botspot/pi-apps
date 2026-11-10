#!/usr/bin/env python3

import subprocess
import threading
import webbrowser
from urllib.parse import quote

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Atk", "1.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Atk, Gdk, GLib, Gtk


class YandexSearchBox(Gtk.Window):
    def __init__(self):
        super().__init__(title="Yandex Arama Kutusu")
        self.set_default_size(720, 360)
        self.set_border_width(12)
        self.busy = False
        self.closed = False
        self.connect("destroy", self.on_destroy)
        self.connect("key-press-event", self.on_key_press)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        self.add(box)

        label = Gtk.Label.new_with_mnemonic("_Arama Terimi:")
        label.set_xalign(0)
        box.pack_start(label, False, False, 0)

        self.entry = Gtk.Entry()
        label.set_mnemonic_widget(self.entry)
        self.entry.get_accessible().set_description(
            "Aranacak metni yazın ve Enter'a basın. Alt+A ile bu alana dönün."
        )
        self.entry.connect("activate", self.on_search)
        box.pack_start(self.entry, False, False, 0)

        self.search_button = Gtk.Button(label="Ara")
        self.search_button.connect("clicked", self.on_search)
        box.pack_start(self.search_button, False, False, 0)

        self.results = Gtk.ListStore(str, str, str)
        self.tree = Gtk.TreeView(model=self.results)
        self.tree.get_accessible().set_name("Yandex arama bağlantısı")
        self.tree.get_accessible().set_description(
            "Arama sonuçları tarayıcıda gösterilir. Seçili bağlantıyı Enter ile açın."
        )
        for index, title in enumerate(("Başlık", "Özet", "Bağlantı")):
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(title, renderer, text=index)
            column.set_resizable(True)
            self.tree.append_column(column)
        self.tree.connect("row-activated", self.on_result_activated)
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroll.add(self.tree)
        box.pack_start(scroll, True, True, 0)

        self.status = Gtk.Label(label="Arama terimini yazın.")
        self.status.set_xalign(0)
        self.status.set_line_wrap(True)
        self.status.get_accessible().set_role(Atk.Role.STATUSBAR)
        box.pack_start(self.status, False, False, 0)
        self.entry.grab_focus()

    @staticmethod
    def speak(message):
        try:
            subprocess.run(
                ["spd-say", "-l", "tr", message],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=5,
                check=False,
            )
        except (OSError, subprocess.TimeoutExpired):
            pass

    def notify(self, message):
        self.status.set_text(message)
        threading.Thread(target=self.speak, args=(message,), daemon=True).start()

    def on_search(self, _widget):
        if self.busy:
            return
        term = self.entry.get_text().strip()
        if not term:
            self.notify("Lütfen bir arama terimi yazın.")
            self.entry.grab_focus()
            return
        url = "https://yandex.com.tr/search/?text=" + quote(term, safe="")
        self.results.clear()
        self.results.append(
            [f"Yandex: {term}", "Sonuçları varsayılan tarayıcıda aç.", url]
        )
        self.tree.get_selection().select_path(Gtk.TreePath.new_from_indices([0]))
        self.open_url(url, "Yandex'te aranıyor...")

    def on_result_activated(self, tree, path, _column):
        if not self.busy:
            self.open_url(tree.get_model()[path][2], "Sonuçlar açılıyor...")

    def open_url(self, url, message):
        self.busy = True
        self.search_button.set_sensitive(False)
        self.tree.set_sensitive(False)
        self.notify(message)
        threading.Thread(target=self.open_worker, args=(url,), daemon=True).start()

    def open_worker(self, url):
        try:
            opened = webbrowser.open(url, new=2)
        except Exception:
            opened = False
        GLib.idle_add(self.finish_open, opened)

    def finish_open(self, opened):
        if self.closed:
            return GLib.SOURCE_REMOVE
        self.busy = False
        self.search_button.set_sensitive(True)
        self.tree.set_sensitive(True)
        if opened:
            self.notify(
                "Sonuçlar tarayıcıda açılıyor. Bağlantıyı Enter ile yeniden açabilirsiniz."
            )
            self.tree.grab_focus()
            self.tree.set_cursor(Gtk.TreePath.new_from_indices([0]))
        else:
            self.notify("Tarayıcı açılamadı. Varsayılan tarayıcı ayarlarınızı kontrol edin.")
            self.entry.grab_focus()
        return GLib.SOURCE_REMOVE

    def on_key_press(self, _widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()
            return True
        return False

    def on_destroy(self, _widget):
        self.closed = True
        if Gtk.main_level():
            Gtk.main_quit()


def main():
    window = YandexSearchBox()
    window.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()

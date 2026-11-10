import sys
import os
import threading
import subprocess
import gi

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib

class YouTubeMediaDownloader(Gtk.Window):
    def __init__(self):
        super().__init__(title="YouTube Media Downloader")
        self.set_default_size(600, 480)
        self.set_position(Gtk.WindowPosition.CENTER)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        vbox.set_border_width(15)
        self.add(vbox)

        lbl_url = Gtk.Label(label="YouTube Bağlantısı:")
        lbl_url.set_alignment(0, 0.5)
        vbox.pack_start(lbl_url, False, False, 0)

        self.entry_url = Gtk.Entry()
        self.entry_url.set_placeholder_text("https://www.youtube.com/...")
        vbox.pack_start(self.entry_url, False, False, 0)

        lbl_type = Gtk.Label(label="İndirme Türü:")
        lbl_type.set_alignment(0, 0.5)
        vbox.pack_start(lbl_type, False, False, 0)

        self.combo_type = Gtk.ComboBoxText()
        self.combo_type.append("video", "Tek Video İndir")
        self.combo_type.append("playlist", "Oynatma Listesi İndir")
        self.combo_type.append("channel", "Kanalın Tamamını İndir")
        self.combo_type.set_active(0)
        vbox.pack_start(self.combo_type, False, False, 0)

        lbl_format = Gtk.Label(label="İndirme Formatı:")
        lbl_format.set_alignment(0, 0.5)
        vbox.pack_start(lbl_format, False, False, 0)

        self.combo_format = Gtk.ComboBoxText()
        self.combo_format.append("mp3", "MP3 (Sadece Ses)")
        self.combo_format.append("mp4", "MP4 (Video + Ses)")
        self.combo_format.set_active(0)
        vbox.pack_start(self.combo_format, False, False, 0)

        self.btn_download = Gtk.Button(label="İndirmeyi Başlat")
        self.btn_download.connect("clicked", self.on_download_clicked)
        vbox.pack_start(self.btn_download, False, False, 10)

        self.lbl_status = Gtk.Label(label="Hazır. Bağlantıyı yapıştırıp İndirmeyi Başlat butonuna basın.")
        self.lbl_status.set_line_wrap(True)
        vbox.pack_start(self.lbl_status, False, False, 10)

    def update_status(self, text):
        GLib.idle_add(self.lbl_status.set_text, text)

    def on_download_clicked(self, widget):
        url = self.entry_url.get_text().strip()
        if not url:
            self.update_status("Hata: Lütfen geçerli bir YouTube bağlantısı girin!")
            return

        download_type = self.combo_type.get_active_id()
        fmt = self.combo_format.get_active_id()
        self.btn_download.set_sensitive(False)
        self.update_status("İndirme işlemi başlatıldı, yt-dlp çalıştırılıyor...")

        threading.Thread(target=self.run_download, args=(url, download_type, fmt), daemon=True).start()

    def run_download(self, url, download_type, fmt):
        home = os.path.expanduser("~")
        download_dir = os.path.join(home, "Downloads")
        os.makedirs(download_dir, exist_ok=True)

        cmd = ["yt-dlp", "-P", download_dir, "--newline", "--no-mtime"]

        if download_type == "video":
            cmd.append("--no-playlist")
        elif download_type in ["playlist", "channel"]:
            cmd.append("--yes-playlist")

        if fmt == "mp3":
            cmd.extend(["-x", "--audio-format", "mp3"])
        else:
            cmd.extend(["-f", "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"])

        cmd.append(url)

        try:
            proc = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1
            )
            
            for line in iter(proc.stdout.readline, ''):
                line_str = line.strip()
                if "[download]" in line_str and "%" in line_str:
                    self.update_status(f"İndiriliyor: {line_str}")
                elif "Destination:" in line_str:
                    self.update_status("Dosya hazırlanıyor ve dönüştürülüyor...")

            proc.stdout.close()
            proc.wait()

            if proc.returncode == 0:
                self.update_status("İndirme başarıyla tamamlandı! Dosya Downloads klasörüne kaydedildi.")
            else:
                self.update_status(f"Hata: İndirme başarısız oldu. Hata Kodu: {proc.returncode}")
        except Exception as e:
            self.update_status(f"Sistem Hatası: {str(e)}")

        GLib.idle_add(self.btn_download.set_sensitive, True)

if __name__ == "__main__":
    win = YouTubeMediaDownloader()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()

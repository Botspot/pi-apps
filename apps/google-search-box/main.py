#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib
import webbrowser
import urllib.parse
import subprocess

class GoogleSearchBox(Gtk.Window):
    def __init__(self):
        super().__init__(title="Google Arama Kutusu")
        self.set_default_size(450, 150)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_border_width(15)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(vbox)

        # Etiket / Başlık
        label = Gtk.Label(label="Google'da Aramak İstediğiniz Terimi Girin:")
        label.set_alignment(0, 0.5)
        vbox.pack_start(label, False, False, 0)

        # Arama Giriş Kutusu
        self.entry = Gtk.Entry()
        self.entry.set_placeholder_text("Arama yapın veya URL yazın...")
        self.entry.connect("activate", self.on_search_clicked)
        vbox.pack_start(self.entry, False, False, 0)

        # Butonlar Kutusu
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        vbox.pack_start(hbox, False, False, 0)

        self.btn_search = Gtk.Button(label="Google'da Ara")
        self.btn_search.connect("clicked", self.on_search_clicked)
        hbox.pack_start(self.btn_search, True, True, 0)

        self.btn_clear = Gtk.Button(label="Temizle")
        self.btn_clear.connect("clicked", self.on_clear_clicked)
        hbox.pack_start(self.btn_clear, True, True, 0)

        # Erişilebilirlik sesli duyurusu
        GLib.timeout_add(300, self.announce_ready)

    def speak(self, text):
        try:
            subprocess.Popen(["spd-say", "-l", "tr", text])
        except Exception:
            pass

    def announce_ready(self):
        self.speak("Google Arama Kutusu hazır. Aranacak kelimeyi girin.")
        self.entry.grab_focus()
        return False

    def on_search_clicked(self, widget):
        query = self.entry.get_text().strip()
        if not query:
            self.speak("Lütfen aramak için bir metin girin.")
            return

        self.speak(f"{query} aranıyor...")
        
        # Eğer doğrudan http/https linkiyse siteyi aç, değilse Google'da ara
        if query.startswith("http://") or query.startswith("https://"):
            url = query
        else:
            encoded_query = urllib.parse.quote(query)
            url = f"https://www.google.com/search?q={encoded_query}"
        
        webbrowser.open(url)
        self.entry.set_text("")

    def on_clear_clicked(self, widget):
        self.entry.set_text("")
        self.entry.grab_focus()
        self.speak("Arama kutusu temizlendi.")

def main():
    app = GoogleSearchBox()
    app.connect("destroy", Gtk.main_quit)
    app.show_all()
    Gtk.main()

if __name__ == "__main__":
    main()

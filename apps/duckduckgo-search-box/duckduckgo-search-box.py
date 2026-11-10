#!/usr/bin/env python3

import subprocess
import threading
import urllib.error
import urllib.parse
import urllib.request
import webbrowser
from http.client import HTTPException
from html.parser import HTMLParser

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk, GLib, Gtk


def safe_url(url):
    url = urllib.parse.urljoin("https://duckduckgo.com/", url)
    parsed = urllib.parse.urlsplit(url)
    if parsed.hostname in ("duckduckgo.com", "html.duckduckgo.com"):
        url = urllib.parse.parse_qs(parsed.query).get("uddg", [url])[0]
        parsed = urllib.parse.urlsplit(url)
    if parsed.scheme in ("http", "https") and parsed.hostname:
        return url
    return None


class ResultParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.results = []
        self.capture = None
        self.depth = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        classes = attrs.get("class", "").split()
        if self.capture:
            if tag not in ("br", "img", "hr", "input", "meta", "link", "wbr"):
                self.depth += 1
            return
        if tag == "a" and "result__a" in classes:
            self.results.append(["", "", safe_url(attrs.get("href", ""))])
            self.capture = "title"
        elif "result__snippet" in classes and self.results:
            self.capture = "snippet"
        else:
            return
        self.parts = []
        self.depth = 1

    def handle_data(self, data):
        if self.capture:
            self.parts.append(data)

    def handle_endtag(self, tag):
        if not self.capture:
            return
        if tag in ("br", "img", "hr", "input", "meta", "link", "wbr"):
            return
        self.depth -= 1
        if self.depth == 0:
            index = 0 if self.capture == "title" else 1
            self.results[-1][index] = " ".join("".join(self.parts).split())
            self.capture = None


def fetch_results(query):
    url = "https://html.duckduckgo.com/html/?" + urllib.parse.urlencode({"q": query})
    request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(request, timeout=15) as response:
        html = response.read(2_000_000).decode("utf-8", errors="replace")
    parser = ResultParser()
    parser.feed(html)
    return [row for row in parser.results if row[0] and row[2]][:20]


def speak(message):
    def worker():
        try:
            subprocess.run(
                ["spd-say", "-l", "tr", message],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=10,
                check=False,
            )
        except (OSError, subprocess.TimeoutExpired):
            pass

    threading.Thread(target=worker, daemon=True).start()


class SearchWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="DuckDuckGo Arama Kutusu")
        self.set_default_size(760, 420)
        self.set_border_width(12)
        self.busy = False
        self.closed = False
        self.connect("destroy", self.on_destroy)
        self.connect("key-press-event", self.on_key_press)

        layout = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        self.add(layout)
        label = Gtk.Label.new_with_mnemonic("_Arama Terimi:")
        label.set_xalign(0)
        layout.pack_start(label, False, False, 0)
        self.entry = Gtk.Entry()
        label.set_mnemonic_widget(self.entry)
        self.entry.get_accessible().set_name("Arama Terimi:")
        self.entry.connect("activate", self.start_search)
        layout.pack_start(self.entry, False, False, 0)
        self.button = Gtk.Button(label="Ara")
        self.button.connect("clicked", self.start_search)
        layout.pack_start(self.button, False, False, 0)

        self.model = Gtk.ListStore(str, str, str)
        self.results = Gtk.TreeView(model=self.model)
        self.results.get_accessible().set_name("Arama sonuçları")
        self.results.get_accessible().set_description(
            "Ok tuşlarıyla sonuç seçin, Enter ile varsayılan tarayıcıda açın."
        )
        for index, title in enumerate(("Başlık", "Özet", "Bağlantı")):
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(title, renderer, text=index)
            column.set_resizable(True)
            self.results.append_column(column)
        self.results.connect("row-activated", self.open_result)
        scroller = Gtk.ScrolledWindow()
        scroller.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scroller.add(self.results)
        layout.pack_start(scroller, True, True, 0)

        self.status = Gtk.Label(label="Arama terimini yazıp Enter veya Ara düğmesine basın.")
        self.status.set_xalign(0)
        self.status.set_line_wrap(True)
        self.status.get_accessible().set_name("Arama durumu")
        layout.pack_start(self.status, False, False, 0)
        self.entry.grab_focus()

    def announce(self, message):
        self.status.set_text(message)
        speak(message)

    def on_destroy(self, widget):
        self.closed = True
        Gtk.main_quit()

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()
            return True
        if event.state & Gdk.ModifierType.MOD1_MASK and event.keyval in (
            Gdk.KEY_a, Gdk.KEY_A
        ):
            self.entry.grab_focus()
            return True
        return False

    def start_search(self, widget):
        if self.busy:
            return
        query = self.entry.get_text().strip()
        if not query:
            self.announce("Lütfen bir arama terimi yazın.")
            self.entry.grab_focus()
            return
        self.busy = True
        self.button.set_sensitive(False)
        self.model.clear()
        url = "https://duckduckgo.com/?" + urllib.parse.urlencode({"q": query})
        self.model.append([
            "DuckDuckGo sonuçları: " + query,
            "Tüm sonuçları tarayıcıda açmak için Enter tuşuna basın.",
            url,
        ])
        self.announce("DuckDuckGo'da aranıyor...")
        threading.Thread(target=self.search_worker, args=(query,), daemon=True).start()

    def search_worker(self, query):
        try:
            rows = fetch_results(query)
            message = (
                f"{len(rows)} sonuç yüklendi. Ok tuşlarıyla seçip Enter ile açın."
                if rows else
                "Sonuç listesi alınamadı. Tüm sonuçları DuckDuckGo bağlantısıyla açabilirsiniz."
            )
        except (OSError, urllib.error.URLError, HTTPException, ValueError):
            rows = []
            message = "Arama sırasında bağlantı hatası oluştu. DuckDuckGo bağlantısını açabilirsiniz."
        GLib.idle_add(self.finish_search, rows, message)

    def finish_search(self, rows, message):
        if self.closed:
            return False
        for row in rows:
            self.model.append(row)
        self.busy = False
        self.button.set_sensitive(True)
        self.results.set_cursor(Gtk.TreePath.new_from_indices([0]))
        self.results.grab_focus()
        self.announce(message)
        return False

    def open_result(self, tree, path, column):
        url = self.model[path][2]
        self.announce("Sonuçlar açılıyor...")
        threading.Thread(target=self.browser_worker, args=(url,), daemon=True).start()

    def browser_worker(self, url):
        try:
            opened = webbrowser.open(url, new=2)
        except (OSError, webbrowser.Error):
            opened = False
        if not opened:
            GLib.idle_add(self.browser_error)

    def browser_error(self):
        if not self.closed:
            self.announce("Tarayıcı açılamadı. Lütfen varsayılan tarayıcı ayarlarını kontrol edin.")
        return False


if __name__ == "__main__":
    window = SearchWindow()
    window.show_all()
    Gtk.main()

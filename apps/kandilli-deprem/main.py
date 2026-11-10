#!/usr/bin/env python3
import sys
import os
import json
import urllib.parse
import webbrowser
import threading
import time
import feedparser

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, GLib, Gdk

CONFIG_FILE = os.path.expanduser("~/.config/kandilli_deprem_config.json")
RSS_URL = "http://koeri.boun.edu.tr/rss/"

def load_config():
    if os.path.exists(CONFIG_FILE):
        try:
            with open(CONFIG_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception:
            pass
    return {"min_mag": 0.0}

def save_config(config):
    os.makedirs(os.path.dirname(CONFIG_FILE), exist_ok=True)
    with open(CONFIG_FILE, 'w', encoding='utf-8') as f:
        json.dump(config, f, ensure_ascii=False, indent=2)

class DetailWindow(Gtk.Window):
    def __init__(self, parent, data):
        super().__init__(title=f"Deprem Detayı: {data['location']}")
        self.set_transient_for(parent)
        self.set_modal(True)
        self.set_default_size(450, 320)
        self.set_position(Gtk.WindowPosition.CENTER_ON_PARENT)
        self.set_border_width(15)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(box)

        title_label = Gtk.Label()
        title_label.set_markup(f"<big><b>{data['location']}</b></big>")
        box.pack_start(title_label, False, False, 5)

        grid = Gtk.Grid()
        grid.set_column_spacing(15)
        grid.set_row_spacing(8)
        box.pack_start(grid, False, False, 10)

        fields = [
            ("Büyüklük:", f"{data['mag']}"),
            ("Tarih / Saat:", f"{data['date']}"),
            ("Derinlik:", f"{data['depth']}"),
            ("Enlem:", f"{data['lat']}"),
            ("Boylam:", f"{data['lng']}"),
        ]

        for i, (label_text, val_text) in enumerate(fields):
            lbl = Gtk.Label(label=label_text)
            lbl.set_halign(Gtk.Align.END)
            val = Gtk.Label(label=val_text)
            val.set_halign(Gtk.Align.START)
            val.set_selectable(True)
            grid.attach(lbl, 0, i, 1, 1)
            grid.attach(val, 1, i, 1, 1)

        btn_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.pack_start(btn_box, False, False, 10)

        map_btn = Gtk.Button(label="Haritada Göster (Google Maps)")
        map_btn.connect("clicked", self.on_map_clicked, data['lat'], data['lng'], data['location'])
        btn_box.pack_start(map_btn, True, True, 0)

        close_btn = Gtk.Button(label="Kapat")
        close_btn.connect("clicked", lambda b: self.destroy())
        btn_box.pack_start(close_btn, False, False, 0)

        self.show_all()

    def on_map_clicked(self, widget, lat, lng, location):
        if lat != "N/A" and lng != "N/A":
            url = f"https://www.google.com/maps/search/?api=1&query={lat},{lng}"
        else:
            encoded_loc = urllib.parse.quote(location)
            url = f"https://www.google.com/maps/search/?api=1&query={encoded_loc}"
        webbrowser.open(url)

class SettingsWindow(Gtk.Window):
    def __init__(self, parent, main_app):
        super().__init__(title="Ayarlar - Bildirim Eşiği")
        self.parent_app = main_app
        self.set_transient_for(parent)
        self.set_modal(True)
        self.set_default_size(380, 220)
        self.set_position(Gtk.WindowPosition.CENTER_ON_PARENT)
        self.set_border_width(15)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.add(box)

        lbl = Gtk.Label(label="Hangi büyüklük ve üzerindeki depremlerde bildirim gönderilsin?")
        lbl.set_line_wrap(True)
        box.pack_start(lbl, False, False, 5)

        self.combo = Gtk.ComboBoxText()
        self.options = [
            ("Tüm bildirimleri gönder (Filtresiz)", 0.0),
            ("0.0 ve üzeri bildirim gönder", 0.0),
            ("1.0 ve üzeri bildirim gönder", 1.0),
            ("2.0 ve üzeri bildirim gönder", 2.0),
            ("3.0 ve üzeri bildirim gönder", 3.0),
            ("4.0 ve üzeri bildirim gönder", 4.0),
            ("5.0 ve üzeri bildirim gönder", 5.0),
            ("6.0 ve üzeri bildirim gönder", 6.0),
        ]

        current_min = self.parent_app.config.get("min_mag", 0.0)
        active_idx = 0
        for i, (text, val) in enumerate(self.options):
            self.combo.append_text(text)
            if i > 0 and abs(val - current_min) < 0.01:
                active_idx = i

        self.combo.set_active(active_idx)
        box.pack_start(self.combo, False, False, 5)

        save_btn = Gtk.Button(label="Kaydet")
        save_btn.connect("clicked", self.on_save)
        box.pack_start(save_btn, False, False, 10)

        self.show_all()

    def on_save(self, widget):
        idx = self.combo.get_active()
        if idx >= 0:
            val = self.options[idx][1]
            self.parent_app.config["min_mag"] = val
            save_config(self.parent_app.config)
        self.destroy()

class KandilliApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="Kandilli Deprem Takip")
        self.set_default_size(800, 500)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.connect("destroy", Gtk.main_quit)

        self.config = load_config()
        self.seen_ids = set()

        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=5)
        self.add(main_box)

        toolbar = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        toolbar.set_border_width(10)
        main_box.pack_start(toolbar, False, False, 0)

        title = Gtk.Label()
        title.set_markup("<b>Kandilli Rasathanesi Son Depremler</b>")
        toolbar.pack_start(title, False, False, 0)

        refresh_btn = Gtk.Button(label="Yenile")
        refresh_btn.connect("clicked", lambda b: self.fetch_data_async())
        toolbar.pack_end(refresh_btn, False, False, 0)

        settings_btn = Gtk.Button(label="Ayarlar")
        settings_btn.connect("clicked", self.on_settings_clicked)
        toolbar.pack_end(settings_btn, False, False, 0)

        sw = Gtk.ScrolledWindow()
        sw.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        main_box.pack_start(sw, True, True, 0)

        self.store = Gtk.ListStore(str, str, str, str, str, str)
        self.treeview = Gtk.TreeView(model=self.store)
        self.treeview.set_property("activate-on-single-click", False)
        self.treeview.connect("row-activated", self.on_row_activated)

        cols = [("Tarih / Saat", 0), ("Konum", 1), ("Büyüklük", 2), ("Derinlik", 3)]
        for title_text, col_idx in cols:
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(title_text, renderer, text=col_idx)
            column.set_sort_column_id(col_idx)
            self.treeview.append_column(column)

        sw.add(self.treeview)

        status_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        status_box.set_border_width(5)
        main_box.pack_start(status_box, False, False, 0)

        self.status_label = Gtk.Label(label="Veriler yükleniyor...")
        self.status_label.set_halign(Gtk.Align.START)
        status_box.pack_start(self.status_label, True, True, 0)

        detail_hint = Gtk.Label(label="Detaylar için listeden depreme tıklayın.")
        detail_hint.set_halign(Gtk.Align.END)
        status_box.pack_end(detail_hint, False, False, 0)

        self.show_all()
        self.fetch_data_async()

    def on_settings_clicked(self, widget):
        SettingsWindow(self, self)

    def on_row_activated(self, treeview, path, column):
        model = treeview.get_model()
        iter_ = model.get_iter(path)
        data = {
            "date": model.get_value(iter_, 0),
            "location": model.get_value(iter_, 1),
            "mag": model.get_value(iter_, 2),
            "depth": model.get_value(iter_, 3),
            "lat": model.get_value(iter_, 4),
            "lng": model.get_value(iter_, 5),
        }
        DetailWindow(self, data)

    def parse_item(self, entry):
        title = entry.get("title", "")
        summary = entry.get("summary", "")
        entry_id = entry.get("id", title)

        mag = "0.0"
        location = title
        date_str = entry.get("published", "")

        parts = title.split("-")
        if len(parts) >= 2:
            mag = parts[0].strip()
            location = "-".join(parts[1:]).strip()

        lat = "N/A"
        lng = "N/A"
        depth = "N/A"

        if "geo_lat" in entry:
            lat = entry["geo_lat"]
        if "geo_long" in entry:
            lng = entry["geo_long"]

        if summary:
            for s in summary.split("<br>"):
                if "Derinlik:" in s:
                    depth = s.replace("Derinlik:", "").strip()

        return {
            "id": entry_id,
            "date": date_str,
            "location": location,
            "mag": mag,
            "depth": depth,
            "lat": lat,
            "lng": lng
        }

    def fetch_data_async(self):
        self.status_label.set_text("Veriler güncelleniyor...")
        threading.Thread(target=self.worker_fetch, daemon=True).start()

    def worker_fetch(self):
        try:
            feed = feedparser.parse(RSS_URL)
            items = []
            for entry in feed.entries:
                parsed = self.parse_item(entry)
                items.append(parsed)

            GLib.idle_add(self.update_ui, items)
        except Exception as e:
            GLib.idle_add(self.status_label.set_text, f"Hata oluştu: {str(e)}")

    def update_ui(self, items):
        self.store.clear()
        min_mag = self.config.get("min_mag", 0.0)

        for item in items:
            self.store.append([
                item["date"],
                item["location"],
                item["mag"],
                item["depth"],
                item["lat"],
                item["lng"]
            ])

            if item["id"] not in self.seen_ids:
                self.seen_ids.add(item["id"])
                try:
                    mag_float = float(item["mag"])
                    if mag_float >= min_mag:
                        self.send_notification(item)
                except ValueError:
                    pass

        self.status_label.set_text(f"Son güncelleme: {time.strftime('%H:%M:%S')} - Toplam: {len(items)} deprem")

    def send_notification(self, item):
        try:
            import subprocess
            msg = f"{item['location']}\nBüyüklük: {item['mag']} | Derinlik: {item['depth']}"
            subprocess.Popen(["notify-send", "Kandilli Deprem Bildirimi", msg])
        except Exception:
            pass

if __name__ == "__main__":
    app = KandilliApp()
    Gtk.main()

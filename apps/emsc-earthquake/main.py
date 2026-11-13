#!/usr/bin/env python3
import json
import threading
import urllib.parse
import urllib.request
import webbrowser
from datetime import datetime, timezone
import subprocess
import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib


class EarthquakeApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="EMSC Global Earthquake Tracker")
        self.set_default_size(900, 600)
        self.set_border_width(10)

        self.all_events = []

        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=8)
        self.add(main_box)

        filter_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        main_box.pack_start(filter_box, False, False, 0)

        mag_label = Gtk.Label(label="Min Magnitude:")
        filter_box.pack_start(mag_label, False, False, 0)

        self.mag_combo = Gtk.ComboBoxText()
        for mag in ["1.0", "2.0", "3.0", "4.0", "5.0", "6.0"]:
            self.mag_combo.append_text(mag)
        self.mag_combo.set_active(2)
        self.mag_combo.get_accessible().set_name("Minimum magnitude selection")
        self.mag_combo.connect("changed", lambda w: self.fetch_data())
        filter_box.pack_start(self.mag_combo, False, False, 0)

        search_label = Gtk.Label(label="Filter Region / Country:")
        filter_box.pack_start(search_label, False, False, 0)

        self.search_entry = Gtk.Entry()
        self.search_entry.set_placeholder_text("e.g. Turkey, Japan, California...")
        self.search_entry.get_accessible().set_name("Region or country search box")
        self.search_entry.connect("changed", self.apply_filter)
        filter_box.pack_start(self.search_entry, True, True, 0)

        self.refresh_btn = Gtk.Button(label="Refresh")
        self.refresh_btn.get_accessible().set_name("Refresh earthquake data")
        self.refresh_btn.connect("clicked", lambda w: self.fetch_data())
        filter_box.pack_start(self.refresh_btn, False, False, 0)

        self.speech_check = Gtk.CheckButton(label="Voice Announcements")
        self.speech_check.set_active(True)
        self.speech_check.get_accessible().set_name("Enable or disable spoken announcements")
        filter_box.pack_start(self.speech_check, False, False, 0)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        main_box.pack_start(scrolled, True, True, 0)

        self.store = Gtk.ListStore(str, str, str, str, str, float, float, str)
        self.tree = Gtk.TreeView(model=self.store)
        self.tree.get_accessible().set_name("Recent earthquakes list")
        self.tree.connect("row-activated", self.on_row_activated)
        scrolled.add(self.tree)

        columns = [
            ("Magnitude", 0, 100),
            ("Region / Location", 1, 340),
            ("Depth (km)", 2, 110),
            ("Time (UTC)", 3, 180),
            ("Coordinates", 4, 150),
        ]

        for title, col_id, width in columns:
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(title, renderer, text=col_id)
            column.set_min_width(width)
            column.set_resizable(True)
            column.set_sort_column_id(col_id)
            self.tree.append_column(column)

        bottom_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        main_box.pack_start(bottom_box, False, False, 0)

        self.status_label = Gtk.Label(label="Ready.")
        self.status_label.set_xalign(0)
        bottom_box.pack_start(self.status_label, True, True, 0)

        self.map_btn = Gtk.Button(label="View on Map")
        self.map_btn.get_accessible().set_name("Open selected earthquake location on map")
        self.map_btn.connect("clicked", self.open_selected_map)
        bottom_box.pack_end(self.map_btn, False, False, 0)

        self.fetch_data()

    def speak(self, text):
        if self.speech_check.get_active():
            try:
                subprocess.Popen(["spd-say", "-C"])
                subprocess.Popen(["spd-say", text])
            except Exception:
                pass

    def fetch_data(self):
        min_mag = self.mag_combo.get_active_text() or "3.0"
        self.status_label.set_text("Fetching earthquake data...")
        self.refresh_btn.set_sensitive(False)

        def worker():
            url = (
                "https://www.seismicportal.eu/fdsnws/event/1/query"
                f"?format=json&limit=100&minmag={urllib.parse.quote(min_mag)}"
            )
            try:
                req = urllib.request.Request(url, headers={"User-Agent": "EMSC-Tracker/1.0"})
                with urllib.request.urlopen(req, timeout=15) as resp:
                    data = json.loads(resp.read().decode("utf-8"))
                features = data.get("features", [])
                GLib.idle_add(self.on_data_loaded, features, None)
            except Exception as exc:
                GLib.idle_add(self.on_data_loaded, [], str(exc))

        threading.Thread(target=worker, daemon=True).start()

    def on_data_loaded(self, features, error):
        self.refresh_btn.set_sensitive(True)
        if error:
            self.status_label.set_text(f"Error: {error}")
            self.speak("Error fetching earthquake data.")
            return

        self.all_events = []
        for feat in features:
            props = feat.get("properties", {})
            geom = feat.get("geometry", {})
            coords = geom.get("coordinates", [0.0, 0.0, 0.0])

            mag = float(props.get("mag", 0.0))
            region = str(props.get("flynn_region", "Unknown Region"))
            depth = round(abs(float(coords[2])), 1) if len(coords) > 2 else 0.0
            lat = round(float(coords[1]), 4) if len(coords) > 1 else 0.0
            lon = round(float(coords[0]), 4) if len(coords) > 0 else 0.0
            raw_time = str(props.get("time", ""))

            try:
                dt = datetime.fromisoformat(raw_time.replace("Z", "+00:00"))
                time_str = dt.astimezone(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
            except Exception:
                time_str = raw_time

            self.all_events.append({
                "mag": f"{mag:.1f}",
                "region": region,
                "depth": f"{depth:.1f}",
                "time": time_str,
                "coord": f"{lat}, {lon}",
                "lat": lat,
                "lon": lon,
                "unid": str(props.get("unid", "")),
            })

        self.apply_filter()

    def apply_filter(self, widget=None):
        query = self.search_entry.get_text().strip().lower()
        self.store.clear()
        count = 0
        for ev in self.all_events:
            if not query or query in ev["region"].lower():
                self.store.append([
                    ev["mag"],
                    ev["region"],
                    ev["depth"],
                    ev["time"],
                    ev["coord"],
                    ev["lat"],
                    ev["lon"],
                    ev["unid"],
                ])
                count += 1

        msg = f"{count} earthquakes listed."
        self.status_label.set_text(msg)
        if widget is None:
            self.speak(msg)

    def open_selected_map(self, widget=None):
        selection = self.tree.get_selection()
        model, treeiter = selection.get_selected()
        if treeiter is not None:
            lat = model[treeiter][5]
            lon = model[treeiter][6]
            webbrowser.open(f"https://www.google.com/maps?q={lat},{lon}")

    def on_row_activated(self, treeview, path, column):
        model = treeview.get_model()
        treeiter = model.get_iter(path)
        if treeiter is not None:
            mag = model[treeiter][0]
            region = model[treeiter][1]
            depth = model[treeiter][2]
            time_str = model[treeiter][3]
            self.speak(f"Magnitude {mag}, {region}, depth {depth} kilometers, time {time_str} UTC")


def main():
    win = EarthquakeApp()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()


if __name__ == "__main__":
    main()

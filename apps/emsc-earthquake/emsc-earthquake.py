#!/usr/bin/env python3
import json
import subprocess
import threading
import urllib.request
import urllib.parse
import webbrowser
from datetime import datetime, timezone

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GLib


def speak(text):
    try:
        subprocess.Popen(
            ["spd-say", "-C"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        subprocess.Popen(
            ["spd-say", "-l", "en", text],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except Exception:
        pass


class DetailDialog(Gtk.Dialog):
    def __init__(self, parent, eq_data):
        super().__init__(
            title=f"Earthquake Details - M{eq_data['mag']} {eq_data['region']}",
            transient_for=parent,
            flags=0
        )
        self.add_buttons(
            "Open in Google Maps", Gtk.ResponseType.APPLY,
            "Close", Gtk.ResponseType.CLOSE
        )
        self.set_default_size(480, 340)
        self.eq_data = eq_data

        box = self.get_content_area()
        box.set_spacing(10)
        box.set_margin_top(12)
        box.set_margin_bottom(12)
        box.set_margin_start(12)
        box.set_margin_end(12)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_vexpand(True)

        text_view = Gtk.TextView()
        text_view.set_editable(False)
        text_view.set_cursor_visible(True)
        text_view.set_wrap_mode(Gtk.WrapMode.WORD)
        text_view.set_left_margin(8)
        text_view.set_right_margin(8)
        text_view.set_top_margin(8)
        text_view.set_bottom_margin(8)

        details_text = (
            f"Region: {eq_data['region']}\n"
            f"Magnitude: {eq_data['mag']} ({eq_data['mag_type']})\n"
            f"Depth: {eq_data['depth']} km\n"
            f"Time (UTC): {eq_data['time_utc']}\n"
            f"Latitude: {eq_data['lat']}\n"
            f"Longitude: {eq_data['lon']}\n"
            f"Event ID: {eq_data['id']}\n"
            f"Source: EMSC-CSEM (European-Mediterranean Seismological Centre)"
        )

        text_view.get_buffer().set_text(details_text)
        scrolled.add(text_view)
        box.add(scrolled)

        self.connect("response", self.on_response)
        self.show_all()
        text_view.grab_focus()
        speak(f"Details for magnitude {eq_data['mag']} in {eq_data['region']}")

    def on_response(self, dialog, response_id):
        if response_id == Gtk.ResponseType.APPLY:
            url = f"https://www.google.com/maps?q={self.eq_data['lat']},{self.eq_data['lon']}"
            webbrowser.open(url)
            speak("Opening location in browser")
        else:
            self.destroy()


class EMSCEarthquakeWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="EMSC Global Earthquake Tracker")
        self.set_default_size(820, 540)
        self.set_border_width(10)

        self.earthquakes = []

        main_vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(main_vbox)

        top_hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        main_vbox.pack_start(top_hbox, False, False, 0)

        lbl_mag = Gtk.Label(label="_Min Magnitude:")
        lbl_mag.set_use_underline(True)
        top_hbox.pack_start(lbl_mag, False, False, 0)

        self.combo_mag = Gtk.ComboBoxText()
        for val in ["All (1.0+)", "2.5+", "3.0+", "4.0+", "5.0+", "6.0+"]:
            self.combo_mag.append_text(val)
        self.combo_mag.set_active(0)
        lbl_mag.set_mnemonic_widget(self.combo_mag)
        self.combo_mag.connect("changed", self.on_filter_changed)
        top_hbox.pack_start(self.combo_mag, False, False, 0)

        lbl_search = Gtk.Label(label="_Region Filter:")
        lbl_search.set_use_underline(True)
        top_hbox.pack_start(lbl_search, False, False, 0)

        self.entry_search = Gtk.Entry()
        self.entry_search.set_placeholder_text("e.g. Turkey, Japan, Greece...")
        lbl_search.set_mnemonic_widget(self.entry_search)
        self.entry_search.connect("changed", self.on_search_changed)
        top_hbox.pack_start(self.entry_search, True, True, 0)

        self.btn_refresh = Gtk.Button(label="_Refresh")
        self.btn_refresh.set_use_underline(True)
        self.btn_refresh.connect("clicked", self.on_refresh_clicked)
        top_hbox.pack_start(self.btn_refresh, False, False, 0)

        self.btn_details = Gtk.Button(label="_Details")
        self.btn_details.set_use_underline(True)
        self.btn_details.connect("clicked", self.on_details_clicked)
        top_hbox.pack_start(self.btn_details, False, False, 0)

        scrolled = Gtk.ScrolledWindow()
        scrolled.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scrolled.set_vexpand(True)
        main_vbox.pack_start(scrolled, True, True, 0)

        self.store = Gtk.ListStore(str, str, str, str, int)
        self.tree = Gtk.TreeView(model=self.store)
        self.tree.set_enable_search(True)
        self.tree.set_search_column(2)
        self.tree.connect("row-activated", self.on_row_activated)

        columns = [
            ("Time (UTC)", 0, 170),
            ("Mag", 1, 75),
            ("Region", 2, 390),
            ("Depth (km)", 3, 110),
        ]

        for title, col_id, width in columns:
            renderer = Gtk.CellRendererText()
            column = Gtk.TreeViewColumn(title, renderer, text=col_id)
            column.set_resizable(True)
            column.set_min_width(width)
            column.set_sort_column_id(col_id)
            self.tree.append_column(column)

        scrolled.add(self.tree)

        self.status_label = Gtk.Label(label="Ready.")
        self.status_label.set_xalign(0)
        main_vbox.pack_start(self.status_label, False, False, 0)

        self.connect("key-press-event", self.on_key_press)
        self.connect("destroy", Gtk.main_quit)

        self.fetch_earthquakes()

    def get_selected_min_mag(self):
        text = self.combo_mag.get_active_text()
        if not text or text.startswith("All"):
            return 1.0
        return float(text.replace("+", ""))

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_F5:
            self.fetch_earthquakes()
            return True
        if (event.state & Gdk.ModifierType.CONTROL_MASK) and event.keyval == Gdk.KEY_r:
            self.fetch_earthquakes()
            return True
        if (event.state & Gdk.ModifierType.CONTROL_MASK) and event.keyval == Gdk.KEY_f:
            self.entry_search.grab_focus()
            return True
        return False

    def on_filter_changed(self, combo):
        self.fetch_earthquakes()

    def on_search_changed(self, entry):
        self.populate_tree()

    def on_refresh_clicked(self, button):
        self.fetch_earthquakes()

    def on_details_clicked(self, button):
        self.open_selected_details()

    def on_row_activated(self, treeview, path, column):
        self.open_selected_details()

    def open_selected_details(self):
        selection = self.tree.get_selection()
        model, treeiter = selection.get_selected()
        if treeiter is not None:
            idx = model[treeiter][4]
            if 0 <= idx < len(self.earthquakes):
                DetailDialog(self, self.earthquakes[idx])

    def fetch_earthquakes(self):
        min_mag = self.get_selected_min_mag()
        self.btn_refresh.set_sensitive(False)
        self.status_label.set_text("Fetching global earthquakes from EMSC...")
        speak("Fetching global earthquakes from EMSC")

        thread = threading.Thread(target=self._worker_fetch, args=(min_mag,), daemon=True)
        thread.start()

    def _worker_fetch(self, min_mag):
        params = urllib.parse.urlencode({
            "format": "json",
            "limit": 150,
            "minmag": min_mag,
            "orderby": "time"
        })
        url = f"https://www.seismicportal.eu/fdsnws/event/1/query?{params}"

        try:
            req = urllib.request.Request(
                url,
                headers={"User-Agent": "EMSC-Earthquake-Tracker/1.0"}
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                raw_data = resp.read().decode("utf-8")
                data = json.loads(raw_data)

            features = data.get("features", [])
            parsed = []

            for item in features:
                props = item.get("properties", {})
                geom = item.get("geometry", {})
                coords = geom.get("coordinates", [0, 0, 0])

                raw_time = props.get("time", "")
                try:
                    dt = datetime.fromisoformat(raw_time.replace("Z", "+00:00"))
                    time_str = dt.astimezone(timezone.utc).strftime("%Y-%m-%d %H:%M:%S")
                except Exception:
                    time_str = raw_time

                mag = props.get("mag", 0.0)
                mag_type = props.get("magtype", "M")
                region = props.get("flynn_region", "Unknown Region")
                depth = props.get("depth", coords[2] if len(coords) > 2 else 0.0)
                lat = props.get("lat", coords[1] if len(coords) > 1 else 0.0)
                lon = props.get("lon", coords[0] if len(coords) > 0 else 0.0)
                ev_id = props.get("unid", item.get("id", ""))

                parsed.append({
                    "time_utc": time_str,
                    "mag": f"{float(mag):.1f}",
                    "mag_type": str(mag_type).upper(),
                    "region": str(region),
                    "depth": f"{float(depth):.1f}",
                    "lat": round(float(lat), 4),
                    "lon": round(float(lon), 4),
                    "id": str(ev_id)
                })

            GLib.idle_add(self._on_fetch_success, parsed)
        except Exception as exc:
            GLib.idle_add(self._on_fetch_error, str(exc))

    def _on_fetch_success(self, parsed):
        self.earthquakes = parsed
        self.populate_tree()
        self.btn_refresh.set_sensitive(True)
        count = len(self.store)
        self.status_label.set_text(f"Loaded {count} earthquakes from EMSC.")
        if count > 0:
            latest = self.earthquakes[0]
            speak(f"Loaded {count} earthquakes. Latest: Magnitude {latest['mag']} in {latest['region']}")
        else:
            speak("No earthquakes found matching criteria")

    def _on_fetch_error(self, err_msg):
        self.btn_refresh.set_sensitive(True)
        self.status_label.set_text(f"Error: {err_msg}")
        speak("Failed to fetch earthquake data")

    def populate_tree(self):
        query = self.entry_search.get_text().strip().lower()
        self.store.clear()

        for idx, eq in enumerate(self.earthquakes):
            if query and query not in eq["region"].lower():
                continue
            self.store.append([
                eq["time_utc"],
                eq["mag"],
                eq["region"],
                eq["depth"],
                idx
            ])

        count = len(self.store)
        self.status_label.set_text(f"Showing {count} earthquakes.")
        if count > 0:
            self.tree.set_cursor(Gtk.TreePath.new_first())
            self.tree.grab_focus()


if __name__ == "__main__":
    win = EMSCEarthquakeWindow()
    win.show_all()
    Gtk.main()

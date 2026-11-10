#!/usr/bin/python3
"""GTK3 ile varsayılan tarayıcıda Bing araması açar."""

import sys
import webbrowser
from urllib.parse import urlencode

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gdk, Gtk


class SearchWindow(Gtk.ApplicationWindow):
    def __init__(self, application):
        super().__init__(application=application, title="Bing Arama Kutusu")
        self.set_default_size(480, 160)
        self.set_border_width(18)
        self.connect("key-press-event", self.on_key_press)

        content = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.add(content)

        label = Gtk.Label.new_with_mnemonic("_Arama metni:")
        label.set_xalign(0)
        content.pack_start(label, False, False, 0)

        self.entry = Gtk.Entry()
        self.entry.connect("activate", self.on_search)
        self.entry.get_accessible().set_name("Arama metni")
        self.entry.get_accessible().set_description(
            "Bing'de aranacak metni yazın ve Enter tuşuna basın."
        )
        label.set_mnemonic_widget(self.entry)
        content.pack_start(self.entry, False, False, 0)

        instructions = Gtk.Label(
            label="Sonuçlar varsayılan web tarayıcınızda açılır."
        )
        instructions.set_xalign(0)
        instructions.set_line_wrap(True)
        content.pack_start(instructions, False, False, 0)

        self.search_button = Gtk.Button.new_with_mnemonic("A_ra")
        self.search_button.set_can_default(True)
        self.search_button.get_accessible().set_description(
            "Bing arama sonuçlarını varsayılan web tarayıcısında aç."
        )
        self.search_button.connect("clicked", self.on_search)
        content.pack_start(self.search_button, False, False, 0)
        self.set_default(self.search_button)

    def on_search(self, _button):
        query = self.entry.get_text().strip()
        if not query:
            self.show_error("Lütfen bir arama metni yazın.")
            return

        url = "https://www.bing.com/search?" + urlencode({"q": query})
        try:
            opened = webbrowser.open(url, new=2)
        except (webbrowser.Error, OSError):
            opened = False

        if not opened:
            self.show_error(
                "Web tarayıcısı açılamadı. Sistem ayarlarından varsayılan "
                "web tarayıcınızı seçip yeniden deneyin."
            )

    def show_error(self, message):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            modal=True,
            destroy_with_parent=True,
            message_type=Gtk.MessageType.ERROR,
            buttons=Gtk.ButtonsType.CLOSE,
            text=message,
        )
        dialog.set_title("Bing Arama Kutusu — Hata")
        dialog.run()
        dialog.destroy()
        self.entry.grab_focus()

    def on_key_press(self, _window, event):
        if event.keyval == Gdk.KEY_Escape:
            self.close()
            return True
        if (
            event.state & Gdk.ModifierType.CONTROL_MASK
            and event.keyval in (Gdk.KEY_l, Gdk.KEY_L)
        ):
            self.entry.grab_focus()
            self.entry.select_region(0, -1)
            return True
        return False


class SearchApplication(Gtk.Application):
    def __init__(self):
        super().__init__(application_id="io.github.bing_search_box")
        self.window = None

    def do_activate(self):
        if self.window is None:
            self.window = SearchWindow(self)
            self.window.show_all()
            self.window.entry.grab_focus()
        self.window.present()


if __name__ == "__main__":
    sys.exit(SearchApplication().run(sys.argv))

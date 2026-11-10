import sys
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.1')
from gi.repository import Gtk, WebKit2

class BloggerDesktopWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Blogger Desktop")
        self.set_default_size(1024, 768)
        self.set_position(Gtk.WindowPosition.CENTER)

        # WebKit Ayarları ve Erişilebilirlik
        settings = WebKit2.Settings()
        settings.set_enable_write_console_messages_to_stdout(True)
        settings.set_enable_caret_browsing(True)  # Klavye ile imleç gezintisi (Caret Browsing)
        settings.set_enable_developer_extras(False)

        # WebView Oluşturma
        self.webview = WebKit2.WebView.new_with_settings(settings)
        self.webview.load_uri("https://www.blogger.com")

        # Erişilebilir Container
        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC)
        scrolled_window.add(self.webview)
        self.add(scrolled_window)

if __name__ == "__main__":
    win = BloggerDesktopWindow()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()

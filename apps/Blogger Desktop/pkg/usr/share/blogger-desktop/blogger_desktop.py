import sys
import os
import gi

gi.require_version('Gtk', '3.0')
gi.require_version('WebKit2', '4.1')
from gi.repository import Gtk, WebKit2, Gio

class BloggerDesktopApp(Gtk.Window):
    def __init__(self):
        super().__init__(title="Blogger Masaüstü")
        self.set_default_size(1024, 768)
        self.connect("destroy", Gtk.main_quit)

        header_bar = Gtk.HeaderBar()
        header_bar.set_show_close_button(True)
        header_bar.set_title("Blogger Masaüstü")
        header_bar.set_subtitle("Teknolog Volkan Özdemir")
        self.set_titlebar(header_bar)

        back_btn = Gtk.Button()
        back_icon = Gtk.Image.new_from_icon_name("go-previous-symbolic", Gtk.IconSize.BUTTON)
        back_btn.add(back_icon)
        back_btn.set_tooltip_text("Geri")
        back_btn.connect("clicked", self.on_back_clicked)
        header_bar.pack_start(back_btn)

        forward_btn = Gtk.Button()
        forward_icon = Gtk.Image.new_from_icon_name("go-next-symbolic", Gtk.IconSize.BUTTON)
        forward_btn.add(forward_icon)
        forward_btn.set_tooltip_text("İleri")
        forward_btn.connect("clicked", self.on_forward_clicked)
        header_bar.pack_start(forward_btn)

        reload_btn = Gtk.Button()
        reload_icon = Gtk.Image.new_from_icon_name("view-refresh-symbolic", Gtk.IconSize.BUTTON)
        reload_btn.add(reload_icon)
        reload_btn.set_tooltip_text("Yenile")
        reload_btn.connect("clicked", self.on_reload_clicked)
        header_bar.pack_start(reload_btn)

        home_btn = Gtk.Button()
        home_icon = Gtk.Image.new_from_icon_name("go-home-symbolic", Gtk.IconSize.BUTTON)
        home_btn.add(home_icon)
        home_btn.set_tooltip_text("Blogger Ana Sayfa")
        home_btn.connect("clicked", self.on_home_clicked)
        header_bar.pack_start(home_btn)

        about_btn = Gtk.Button()
        about_icon = Gtk.Image.new_from_icon_name("help-about-symbolic", Gtk.IconSize.BUTTON)
        about_btn.add(about_icon)
        about_btn.set_tooltip_text("Hakkında")
        about_btn.connect("clicked", self.on_about_clicked)
        header_bar.pack_end(about_btn)

        self.web_context = WebKit2.WebContext.get_default()
        self.cookie_manager = self.web_context.get_cookie_manager()
        
        user_data_dir = os.path.expanduser("~/.local/share/blogger-desktop")
        os.makedirs(user_data_dir, exist_ok=True)

        self.cookie_manager.set_persistent_storage(
            os.path.join(user_data_dir, "cookies.sqlite"),
            WebKit2.CookiePersistentStorage.SQLITE
        )

        self.webview = WebKit2.WebView.new_with_context(self.web_context)
        self.webview.load_uri("https://www.blogger.com")
        self.add(self.webview)

    def on_back_clicked(self, button):
        if self.webview.can_go_back():
            self.webview.go_back()

    def on_forward_clicked(self, button):
        if self.webview.can_go_forward():
            self.webview.go_forward()

    def on_reload_clicked(self, button):
        self.webview.reload()

    def on_home_clicked(self, button):
        self.webview.load_uri("https://www.blogger.com")

    def on_about_clicked(self, button):
        about = Gtk.AboutDialog()
        about.set_transient_for(self)
        about.set_program_name("Blogger Masaüstü")
        about.set_version("v1.0.0")
        about.set_comments("Raspberry Pi OS için geliştirilmiş erişilebilir Blogger yönetim aracı.")
        about.set_website("https://volkanozdemir.com.tr")
        about.set_website_label("Teknolog Volkan Özdemir")
        about.run()
        about.destroy()

if __name__ == "__main__":
    app = BloggerDesktopApp()
    app.show_all()
    Gtk.main()

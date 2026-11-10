# DuckDuckGo Arama Kutusu (v1.0.0)

DuckDuckGo Arama Kutusu, Raspberry Pi OS ve Linux masaüstleri için Python 3 ve GTK 3 (PyGObject) altyapısıyla geliştirilmiş, %100 Orca ekran okuyucu ve klavye erişilebilirliğini gözeten hafif bir masaüstü arama uygulamasıdır.

---

## Hızlı Kurulum

Terminalinizde aşağıdaki tek satırlık komutu çalıştırarak uygulamayı `.deb` paketi olarak anında sisteminize kurabilirsiniz:

wget -qO- https://raw.githubusercontent.com/teknologvolkanozdemir/duckduckgo-search-box/main/install | bash

---

## Özellikler ve Kullanım

- %100 Erişilebilir: Orca ekran okuyucu için ATK/AT-SPI etiketleri, etiket-alan ilişkileri ve canlı sesli durum bilgilendirmesi (spd-say).
- Hızlı Web Entegrasyonu: Arama terimini yazıp Enter veya Ara düğmesine basın. Seçili sonucu Enter ile varsayılan tarayıcınızda açabilirsiniz.
- Klavye Kısayolları:
  * Alt+A: Arama alanına odaklan
  * Tab / Shift+Tab: Alanlar arasında gezinme
  * Ok Tuşları: Sonuçlar arasında gezinme
  * Escape: Pencereyi kapat
- Sistem Dostu: Hafif GTK 3 arayüzü ve donma önleyici arka plan iş parçacıkları (threading).

---

## Güvenlik ve Gizlilik

Aramalar arka planda yapılır. DuckDuckGo'nun HTML sonuçları alınamazsa ilk satırdaki bağlantıyla arama sonuç sayfasını doğrudan açabilirsiniz. Arama terimleri DuckDuckGo'ya gönderilir.

---

## Geliştirici

Volkan Özdemir
Web Sitesi: https://www.volkanozdemir.com.tr
GitHub: https://github.com/teknologvolkanozdemir


==================================================


# DuckDuckGo Search Box (v1.0.0 - English)

DuckDuckGo Search Box is a lightweight desktop search utility for Raspberry Pi OS built with Python 3 and GTK 3, fully accessible with Orca screen reader support.

---

## Quick Installation

Run the following command in your terminal:

wget -qO- https://raw.githubusercontent.com/teknologvolkanozdemir/duckduckgo-search-box/main/install | bash

---

## Developer

Volkan Özdemir
Website: https://www.volkanozdemir.com.tr
GitHub: https://github.com/teknologvolkanozdemir

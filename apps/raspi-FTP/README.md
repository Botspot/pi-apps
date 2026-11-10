# raspiFTP (v1.0.0)

raspiFTP, Raspberry Pi OS ve Linux masaüstü sistemleri için Python 3 ve GTK 3 (PyGObject) altyapısıyla geliştirilmiş, %100 Orca ekran okuyucu uyumlu, çift panelli hafif bir FTP/SFTP istemci uygulamasıdır.

---

## Hızlı Kurulum

Terminalinizde aşağıdaki tek satırlık komutu çalıştırarak uygulamayı `.deb` paketi olarak anında sisteminize kurabilirsiniz:

wget -qO- https://raw.githubusercontent.com/teknologvolkanozdemir/raspi-ftp/main/install | bash

---

## Özellikler ve Kullanım

- %100 Erişilebilir: Orca ekran okuyucu için ATK/AT-SPI etiketleri ve canlı sesli durum bilgilendirmesi (spd-say).
- FileZilla Tarzı Çift Panel: Yerel bilgisayar ve uzak sunucu dizin ağacı görünümü ile kolay gezinme.
- Klavye Kısayolları:
  * Alt+S: Sunucu alanına odaklan
  * Alt+B: Hızlı bağlan
  * Alt+Y: Karşıya yükle
  * Alt+I: İndir
  * Alt+R / F5: Her iki paneli yenile
  * F6: Dosya panelleri arasında geçiş
  * Tab / Shift+Tab: Denetimler arasında gezinme
  * Escape: Ana pencereyi kapat / iletişim kutusunu iptal et
- Güvenli ve Donma Önleyici: Parolalar diske kaydedilmez. Arka plan iş parçacıkları (threading) sayesinde bağlantı sırasında arayüz donmaz.

---

## Geliştirici

Volkan Özdemir
Web Sitesi: https://www.volkanozdemir.com.tr
GitHub: https://github.com/teknologvolkanozdemir


==================================================


# raspiFTP (v1.0.0 - English)

raspiFTP is a lightweight, dual-panel FTP/SFTP client for Raspberry Pi OS built with Python 3 and GTK 3, fully accessible with Orca screen reader support.

---

## Quick Installation

Run the following command in your terminal:

wget -qO- https://raw.githubusercontent.com/teknologvolkanozdemir/raspi-ftp/main/install | bash

---

## Developer

Volkan Özdemir
Website: https://www.volkanozdemir.com.tr
GitHub: https://github.com/teknologvolkanozdemir

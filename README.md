# VerdaPot

**ESP32 ve Flutter ile fuzzy logic tabanlı akıllı saksı sulama sistemi.**

VerdaPot, mikrodenetleyiciye gömülü fuzzy mantığı kullanarak bitkinin gerçek
ihtiyacına göre sulama kararı veren ve mobil uygulamadan canlı izlenen
tamamen yerel bir IoT sistemidir. Bulut bağımlılığı yoktur — telefon ve
ESP32 aynı WiFi'da konuşur, internet erişimi gerekmez.

---

## Öne Çıkan Özellikler

- **Otonom karar verme** — Tüm sulama mantığı ESP32'de çalışır; telefon kapalı
  olsa bile bitki ihmal edilmez.
- **Fuzzy logic sulama** — Toprak nemi ve sıcaklık stresi birlikte değerlendirilir;
  pompa süresi `irrigation_power × sulama_sure_max` ile orantılı hesaplanır.
- **NVS profil kalıcılığı** — Elektrik kesilse bile cihaz son seçilen bitki
  profiliyle çalışmaya devam eder.
- **Non-blocking pompa** — Sulama sırasında WiFi ve komut akışı duraksamaz.
- **Şeffaf karar açıklaması** — Her sulama eventinin gerekçesi (hangi fuzzy
  kuralının baskın olduğu) uygulamada gösterilir.
- **15 hazır bitki profili** + kullanıcının kendi bitkisini tanımlayabileceği
  özel profil editörü.
---

## Mimari
---

## Donanım

| Bileşen | Pin | Açıklama |
|---|---|---|
| ESP32 DevKit | — | Ana mikrodenetleyici |
| DHT22 | GPIO 4 | Sıcaklık + bağıl nem |
| BH1750 | I²C (SDA=21, SCL=22) | Işık şiddeti (lux) |
| Kapasitif Toprak Sensörü | ADC1 GPIO 34 | Toprak nemi (0–100%) |
| Mini Dalgıç Pompa + Röle | GPIO 26 | Aktif-LOW röle, 6V pompa |
| Pasif Buzzer | GPIO 25 | Alarm + state geçiş bildirimi |

> Toprak sensörü **mutlaka ADC1**'e (GPIO 32–39) bağlanmalı — ADC2
> kanalları WiFi etkinken çalışmaz.

---

## Klasör Yapısı

```
Smart Pot Monitoring System/
├── firmware/
│   └── smart_pot/
│       ├── smart_pot.ino     # Ana firmware
│       ├── config.h          # Pin, WiFi, default profil ayarları
│       ├── fuzzy.h           # Fuzzy logic motoru (9 kural)
│       └── buzzer.h          # Buzzer ses helper'ları
└── app/
    ├── lib/
    │   ├── main.dart
    │   ├── theme/            # Pastel + glassmorphism tasarım sistemi
    │   ├── widgets/          # PlantAvatar (CustomPainter), GlassCard, AppHeader
    │   ├── dashboard/        # Ana ekran + connectivity monitor
    │   ├── profile/          # Bitki seçimi + özel bitki editörü
    │   ├── pairing/          # Cihaz eşleştirme (IP + token)
    │   ├── history/          # CSV export, fl_chart grafikleri
    │   ├── server/           # Embedded shelf HTTP sunucusu
    │   ├── commands/         # ESP32'ye HTTP komut clienti
    │   ├── notifications/    # Event-tabanlı local bildirimler
    │   ├── data/             # Drift SQLite şeması + repo'lar + seeder
    │   └── settings/         # SharedPreferences yönetimi
    ├── android/              # Android-specific config (manifest, MainActivity)
    └── pubspec.yaml
```

---

## Kurulum

### Firmware (Arduino IDE)

1. **Gerekli kütüphaneler** (Library Manager üzerinden):
   - DHT sensor library
   - BH1750
   - ArduinoJson
2. `firmware/smart_pot/config.h` dosyasını aç ve kendi WiFi bilgilerin ile
   güncelle:
   ```cpp
   #define WIFI_SSID      "TelefonHotspotum"
   #define WIFI_PASSWORD  "sifre1234"
   #define SERVER_IP      "192.168.43.1"      // telefonun hotspot IP'si
   #define DEVICE_TOKEN   "<APP'TEN ALDIĞIN TOKEN>"
   ```
3. ESP32 board paketini yükle, `smart_pot.ino`'yu aç, port seç ve Upload.
4. Serial Monitor'dan boot loglarını izle:
   ```
   [boot] Smart Pot — başlatılıyor
   [NVS] kayıt yok — default profil kullanılıyor
   [WiFi] bağlandı: 192.168.43.155
   [HTTP] server hazır (port 80)
   ```

### Mobil Uygulama (Flutter)

```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --release
```

APK çıktısı: `build/app/outputs/flutter-apk/app-release.apk` — telefona kopyala
ve kur.

---

## İlk Kullanım

1. Telefonun WiFi hotspot'unu aç (config.h'taki SSID ile aynı isimde olmalı).
2. ESP32'yi enerjile — hotspot'a bağlanacak ve `/hello` gönderecek.
3. VerdaPot uygulamasını aç, Ayarlar > **Cihaz Eşleştirme** menüsünden:
   - Telefonun IP'si gösterilir, kopyala ve `config.h`'a `SERVER_IP` olarak yaz
     (gerekirse firmware'i yeniden flashla).
   - Token'ı kopyala, `config.h`'a `DEVICE_TOKEN` olarak yapıştır.
   - **ESP32 Adresi** alanına Serial Monitor'da görünen IP'yi gir
     (örn. `http://192.168.43.155`) ve Kaydet.
4. Üst sağdaki yaprak ikonundan bir bitki seç. Cihaza profil gönderilir,
   30 saniye içinde ilk sensör verisi dashboard'a düşer.

---

## Fuzzy Logic Kuralları

ESP32'deki `fuzzy_irrigate_with_reason()` fonksiyonu üç girdi alır:

- **Toprak nemi** üyelik fonksiyonları: `kuru`, `nemli`, `ıslak`
- (eşik: `toprak_kuru_esik`)
- **Sıcaklık stresi** üyelik fonksiyonları: `stres_soğuk`, `normal`,`stres_sıcak`

4 ağırlıklı kural baskın çıktıyı (`irrigation_power` ∈ [0, 1]) üretir:
 
| Kural | Koşul | Ağırlık | Anlamı |
|---|---|---|---|
| K1 | kuru + sıcak stres | 1.0 | Tam güç sulama |
| K2 | kuru + normal | 0.7 | Standart sulama |
| K3 | kuru + soğuk stres | 0.4 | İhtiyatlı sulama |
| K4 | nemli + sıcak stres | 0.3 | Hafif takviye |

**Defuzzification:** `süre = round(irrigation_power × sulama_sure_max)`

`sulama_sure_max` bitkiye özgüdür (kaktüs için 2 sn, barış çiçeği için 7 sn);
fuzzy bu tavanın yüzdesi kadar sular.

---

## Bitki Avatarları

Dashboard'daki animasyonlu bitki, `CustomPainter` ile çizilir ve üç şekil
varyasyonu vardır:

- **Yapraklı** — Monstera, Pothos, Sarmaşık, Yasemin, Fikus, Drasen
- **Sukulent** — Kaktüs, Yılan Bitkisi (sapsız, dikenli gövdeler)
- **Çiçekli** — Begonya, Barış Çiçeği, Afrika Menekşesi, Ortanca, Kasımpatı,
  Kamelya, Kalatea (yapraklı taban + tepede pastel çiçek)

Her bitki 7 farklı ruh halinde görünür: `thriving`, `thirsty`, `watering`,
`offline`, `noPlant`, `lowLight`, `brightLight`. Renk paleti, animasyon hızı
ve overlay'ler ruh haline göre değişir.

---

## Event Türleri

| Event | Kim üretir | Tetik |
|---|---|---|
| `WATERING_STARTED` | ESP32 | Pompa açıldığında (payload: süre, güç, sebep, tetikleyici) |
| `WATERING_COMPLETED` | ESP32 | Pompa kapandığında |
| `ALARM_START` / `ALARM_END` | ESP32 | TEMP / RH / LIGHT eşik geçişlerinde |
| `NO_PLANT_SELECTED` | ESP32 | NVS boşken her döngü |
| `DEVICE_ONLINE` | ESP32 | `/hello` başarılı olduğunda |
| `MANUAL_PUMP_REJECTED` | ESP32 | Toprak yeterli veya pompa meşgulse |
| `PROFILE_UPDATED` | ESP32 | `/cmd/set_profile` işlendiğinde |
| `DEVICE_OFFLINE` | App (lokal) | `last_seen_at > 90 sn` |

---

## Geliştirici Notları
- **Uzaktan erişim:** Sistem yalnızca aynı LAN'da çalışır. Başka şehirden
  erişim isteniyorsa MQTT broker veya tünel (ngrok, Cloudflare Tunnel)
  eklenmelidir.

---

## Lisans

Bu proje üniversite mikroişlemci dersi kapsamında geliştirilmiştir.

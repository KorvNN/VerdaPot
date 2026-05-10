#pragma once

// ── WiFi ──────────────────────────────────────────────────────────────────────
#define WIFI_SSID      "RedmiNote14Pro"
#define WIFI_PASSWORD  "ehmed123"

// ── App Sunucusu (aynı yerel ağ üzerinden) ───────────────────────────────────
#define SERVER_IP      "10.101.176.226"      // hotspot gateway IP (telefonun hotspot içindeki IP'si)
#define SERVER_PORT    8080
#define INGEST_PATH    "/ingest"
#define EVENT_PATH     "/event"
#define HELLO_PATH     "/hello"

// ── Auth ──────────────────────────────────────────────────────────────────────
// App ile paylaşılan token; tüm gelen komutlarda doğrulanır.
#define DEVICE_TOKEN   "5dcc560fd707d31656e17fc8f8d88c1f"

// ── Pin Tanımları (ESP32) ────────────────────────────────────────────────────
#define PIN_DHT22   4
#define PIN_SDA     21
#define PIN_SCL     22
#define PIN_SOIL    34         // ADC1 zorunlu (WiFi/ADC2 çakışması)
#define PIN_RELAY   26
#define PIN_BUZZER  25

// ── Zamanlama ────────────────────────────────────────────────────────────────
#define LOOP_INTERVAL_MS     3000UL    // sensör + heartbeat döngüsü
#define WIFI_RETRY_INTERVAL  5000UL    // yeniden bağlanma denemesi
#define HTTP_TIMEOUT_MS      5000      // HTTP istek zaman aşımı
#define HELLO_RETRY_MS       30000UL   // /hello başarısızsa tekrar dene

// ── Relay (Active LOW) ───────────────────────────────────────────────────────
#define PUMP_ON   LOW
#define PUMP_OFF  HIGH

// ── Toprak Sensörü ADC Kalibrasyonu ──────────────────────────────────────────
// Bu sensör non-inverted: kuru havada raw düşük, ıslak toprakta raw yüksek.
// Sensör havaya tutulduğunda DRY_RAW, suya daldırıldığında WET_RAW okunur.
#define SOIL_DRY_RAW  10
#define SOIL_WET_RAW  1000

// ── Buzzer PWM (ledc API) ─────────────────────────────────────────────────────
#define BUZZER_LEDC_CHANNEL  0
#define BUZZER_LEDC_FREQ     1000
#define BUZZER_LEDC_RES      8

// ── Default Profil (NVS boşsa kullanılan generic medium aralığı) ─────────────
#define DEFAULT_SICAKLIK_MIN     18.0f
#define DEFAULT_SICAKLIK_MAX     24.0f
#define DEFAULT_SICAKLIK_STRES   4.0f
#define DEFAULT_NEM_MIN          50.0f
#define DEFAULT_NEM_MAX          70.0f
#define DEFAULT_TOPRAK_KURU      45.0f
#define DEFAULT_SULAMA_SURE_MAX  4
#define DEFAULT_ISIK_MIN         807
#define DEFAULT_ISIK_MAX         10764
#define DEFAULT_BITKI_ADI        "Default Medium"

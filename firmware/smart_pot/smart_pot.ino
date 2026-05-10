// Smart Pot Monitoring System — ESP32 Firmware
//
// Mimari:
//   • Aktif bitki profili NVS'te (Preferences API) saklanır. App profili
//     /cmd/set_profile ile gönderir; elektrik kesilse de kaybolmaz.
//   • Tüm sulama kararı cihazda alınır — fuzzy logic toprak nemini ve
//     sıcaklık stresini tartarak ne zaman ve ne kadar sulanacağına karar verir.
//   • Pompa kontrolü non-blocking: millis() tabanlı zamanlama, WiFi yığını ve
//     komut işleyici sulama sırasında duraksamaz.
//   • 30 saniyelik döngü hem ölçüm hem heartbeat görevi görür; app bu sayede
//     90 saniye veri alamayınca cihazı çevrimdışı sayabilir.

#include <Arduino.h>
#include <WiFi.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <Wire.h>
#include <DHT.h>
#include <BH1750.h>
#include <ArduinoJson.h>
#include <Preferences.h>

#include "config.h"
#include "fuzzy.h"
#include "buzzer.h"

// ── Donanım Nesneleri ────────────────────────────────────────────────────────
DHT        dht(PIN_DHT22, DHT22);
BH1750     lightMeter;
WebServer  server(80);
Preferences prefs;

// ── Aktif Profil (fuzzy.h'ın extern referansını besler) ─────────────────────
ActiveProfile g_profile = {
  .sicaklik_min     = DEFAULT_SICAKLIK_MIN,
  .sicaklik_max     = DEFAULT_SICAKLIK_MAX,
  .sicaklik_stres   = DEFAULT_SICAKLIK_STRES,
  .nem_min          = DEFAULT_NEM_MIN,
  .nem_max          = DEFAULT_NEM_MAX,
  .toprak_kuru_esik = DEFAULT_TOPRAK_KURU,
  .sulama_sure_max  = DEFAULT_SULAMA_SURE_MAX,
  .isik_min         = DEFAULT_ISIK_MIN,
  .isik_max         = DEFAULT_ISIK_MAX,
  .bitki_adi        = DEFAULT_BITKI_ADI,
  .bitki_secildi    = false
};

// ── Pompa State (non-blocking) ───────────────────────────────────────────────
enum PumpSource { SRC_AUTO, SRC_MANUAL };

struct PumpState {
  bool          active    = false;
  unsigned long startMs   = 0;
  int           durationS = 0;
  PumpSource    source    = SRC_AUTO;
  // Aktif sulama hakkında event'lere eklenecek bilgiler
  float         last_irrigation_power = 0.0f;
  char          last_sebep[64]        = "";
} g_pump;

// ── Zamanlayıcılar ───────────────────────────────────────────────────────────
unsigned long lastSensorTime  = 0;
unsigned long lastWiFiAttempt = 0;
unsigned long lastHelloTime   = 0;
bool          helloSent       = false;

// ── Alarm Bayrakları (transition tracking) ───────────────────────────────────
bool alarm_temp_low   = false;
bool alarm_temp_high  = false;
bool alarm_rh_low     = false;
bool alarm_rh_high    = false;
bool alarm_light_low  = false;
bool alarm_light_high = false;

// ── Sensör Verisi ────────────────────────────────────────────────────────────
struct SensorData {
  float T;           // sıcaklık (°C)
  float RH;          // bağıl nem (%)
  float soil;        // toprak nemi (0–100)
  int   lux;         // ışık şiddeti
  bool  valid;       // DHT okuması başarılı
  bool  soil_valid;  // ADC beklenen aralıkta
  bool  lux_valid;   // BH1750 geçerli değer döndü
};

// ─────────────────────────────────────────────────────────────────────────────
// Profil Kalıcılığı (NVS / Preferences)
// ─────────────────────────────────────────────────────────────────────────────
void profileLoad() {
  prefs.begin("smartpot", true /* readOnly */);
  bool has = prefs.getBool("has_profile", false);
  if (has) {
    g_profile.sicaklik_min     = prefs.getFloat("t_min",   DEFAULT_SICAKLIK_MIN);
    g_profile.sicaklik_max     = prefs.getFloat("t_max",   DEFAULT_SICAKLIK_MAX);
    g_profile.sicaklik_stres   = prefs.getFloat("t_stres", DEFAULT_SICAKLIK_STRES);
    g_profile.nem_min          = prefs.getFloat("rh_min",  DEFAULT_NEM_MIN);
    g_profile.nem_max          = prefs.getFloat("rh_max",  DEFAULT_NEM_MAX);
    g_profile.toprak_kuru_esik = prefs.getFloat("kuru",    DEFAULT_TOPRAK_KURU);
    g_profile.sulama_sure_max  = prefs.getInt  ("sure_max",DEFAULT_SULAMA_SURE_MAX);
    g_profile.isik_min         = prefs.getInt  ("lux_min", DEFAULT_ISIK_MIN);
    g_profile.isik_max         = prefs.getInt  ("lux_max", DEFAULT_ISIK_MAX);
    String adi = prefs.getString("ad", DEFAULT_BITKI_ADI);
    strncpy(g_profile.bitki_adi, adi.c_str(), sizeof(g_profile.bitki_adi) - 1);
    g_profile.bitki_adi[sizeof(g_profile.bitki_adi) - 1] = '\0';
    g_profile.bitki_secildi = true;
    Serial.printf("[NVS] profil yüklendi: %s\n", g_profile.bitki_adi);
  } else {
    Serial.println("[NVS] kayıt yok — default profil kullanılıyor");
    g_profile.bitki_secildi = false;
  }
  prefs.end();
}

void profileSave() {
  prefs.begin("smartpot", false /* readWrite */);
  prefs.putBool ("has_profile", true);
  prefs.putFloat("t_min",    g_profile.sicaklik_min);
  prefs.putFloat("t_max",    g_profile.sicaklik_max);
  prefs.putFloat("t_stres",  g_profile.sicaklik_stres);
  prefs.putFloat("rh_min",   g_profile.nem_min);
  prefs.putFloat("rh_max",   g_profile.nem_max);
  prefs.putFloat("kuru",     g_profile.toprak_kuru_esik);
  prefs.putInt  ("sure_max", g_profile.sulama_sure_max);
  prefs.putInt  ("lux_min",  g_profile.isik_min);
  prefs.putInt  ("lux_max",  g_profile.isik_max);
  prefs.putString("ad",      g_profile.bitki_adi);
  prefs.end();
  Serial.printf("[NVS] profil kaydedildi: %s\n", g_profile.bitki_adi);
}

// ─────────────────────────────────────────────────────────────────────────────
// SENSÖR OKUMA
// ─────────────────────────────────────────────────────────────────────────────
SensorData readSensors() {
  SensorData d;

  // DHT22
  d.T     = dht.readTemperature();
  d.RH    = dht.readHumidity();
  d.valid = (!isnan(d.T) && !isnan(d.RH));

  // Toprak — 5 örnek ortalama
  // Pompa açıkken (ve kapandıktan 3 sn sonrasına kadar) röleden gelen
  // EMI parazit ADC'yi bozuyor; bu sırada son geçerli okumayı koruyoruz.
  static float last_soil = 50.0f;
  static unsigned long pumpEndedAt = 0;
  if (g_pump.active) {
    pumpEndedAt = millis();    // pompa kapanınca buradan 3sn sayılacak
    d.soil = last_soil;
    d.soil_valid = true;
    Serial.printf("[SOIL] pompa aktif — son deger korunuyor: %.1f%%\n", last_soil);
  } else if (millis() - pumpEndedAt < 3000UL && pumpEndedAt != 0) {
    d.soil = last_soil;
    d.soil_valid = true;
    Serial.printf("[SOIL] pompa cooldown — son deger korunuyor: %.1f%%\n", last_soil);
  } else {
    long sum = 0;
    for (int i = 0; i < 5; i++) {
      sum += analogRead(PIN_SOIL);
      delay(10);
    }
    int raw = (int)(sum / 5);
    d.soil_valid = true;
    float mapped = ((float)(raw - SOIL_WET_RAW) /
                    (float)(SOIL_DRY_RAW - SOIL_WET_RAW)) * -100.0f + 100.0f;
    d.soil = constrain(mapped, 0.0f, 100.0f);
    last_soil = d.soil;
    Serial.printf("[SOIL] raw=%d  mapped=%.1f%%\n", raw, d.soil);
  }

  // BH1750
  float rawLux = lightMeter.readLightLevel();
  d.lux_valid  = (rawLux >= 0.0f);
  d.lux        = d.lux_valid ? (int)rawLux : 0;

  return d;
}

// ─────────────────────────────────────────────────────────────────────────────
// HTTP — Generic POST helper
// ─────────────────────────────────────────────────────────────────────────────
bool httpPost(const char* path, const String& body) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.printf("[HTTP] WiFi yok, atlandı: %s\n", path);
    return false;
  }

  HTTPClient http;
  String url = String("http://") + SERVER_IP + ":" + SERVER_PORT + path;
  http.begin(url);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("X-Device-Token", DEVICE_TOKEN);
  http.setTimeout(HTTP_TIMEOUT_MS);
  int code = http.POST(body);
  bool ok = (code >= 200 && code < 300);
  if (!ok) Serial.printf("[HTTP] POST %s → %d\n", path, code);
  http.end();
  return ok;
}

// ─────────────────────────────────────────────────────────────────────────────
// /ingest gönderimi — periyodik sensör verisi
// ─────────────────────────────────────────────────────────────────────────────
void postIngest(const SensorData& d) {
  StaticJsonDocument<256> doc;
  if (d.valid) {
    doc["sicaklik_c"] = round(d.T  * 10.0f) / 10.0f;
    doc["nem_yuzde"]  = round(d.RH * 10.0f) / 10.0f;
  }
  if (d.soil_valid) doc["toprak_nem"] = (int)d.soil;
  if (d.lux_valid)  doc["isik_lux"]   = d.lux;
  doc["pompa_aktif"] = g_pump.active;
  doc["bitki_adi"]   = g_profile.bitki_adi;

  String body;
  serializeJson(doc, body);
  httpPost(INGEST_PATH, body);
}

// ─────────────────────────────────────────────────────────────────────────────
// /event gönderimi (kind + opsiyonel payload)
// ─────────────────────────────────────────────────────────────────────────────
void postEvent(const char* kind) {
  StaticJsonDocument<128> doc;
  doc["kind"] = kind;
  String body;
  serializeJson(doc, body);
  httpPost(EVENT_PATH, body);
}

void postWateringStarted(int sure, float power, const char* sebep, PumpSource src) {
  StaticJsonDocument<256> doc;
  doc["kind"]             = "WATERING_STARTED";
  doc["sulama_sure"]      = sure;
  doc["irrigation_power"] = round(power * 100.0f) / 100.0f;
  doc["sebep"]            = sebep;
  doc["tetikleyici"]      = (src == SRC_AUTO) ? "AUTO" : "MANUAL";
  String body;
  serializeJson(doc, body);
  httpPost(EVENT_PATH, body);
}

void postManualPumpRejected(const char* reason) {
  StaticJsonDocument<128> doc;
  doc["kind"]   = "MANUAL_PUMP_REJECTED";
  doc["sebep"]  = reason;     // "TOPRAK_YETERLI" veya "POMPA_MESGUL"
  String body;
  serializeJson(doc, body);
  httpPost(EVENT_PATH, body);
}

void postAlarmEvent(const char* kind, const char* type, float value, float limit) {
  StaticJsonDocument<192> doc;
  doc["kind"]  = kind;        // "ALARM_START" veya "ALARM_END"
  doc["type"]  = type;        // "TEMP_LOW", "TEMP_HIGH" ...
  doc["value"] = value;
  doc["limit"] = limit;
  String body;
  serializeJson(doc, body);
  httpPost(EVENT_PATH, body);
}

void postHello() {
  StaticJsonDocument<192> doc;
  doc["hostname"]     = "smartpot";
  doc["firmware_ver"] = "smart_pot_v1";
  doc["mac"]          = WiFi.macAddress();
  String body;
  serializeJson(doc, body);
  if (httpPost(HELLO_PATH, body)) {
    helloSent     = true;
    lastHelloTime = millis();
    postEvent("DEVICE_ONLINE");
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// POMPA — Non-Blocking
// ─────────────────────────────────────────────────────────────────────────────
void pumpStart(int durationS, float power, const char* sebep, PumpSource src) {
  if (g_pump.active) return;  // çift tetiklemeyi engelle
  g_pump.active                 = true;
  g_pump.startMs                = millis();
  g_pump.durationS              = durationS;
  g_pump.source                 = src;
  g_pump.last_irrigation_power  = power;
  strncpy(g_pump.last_sebep, sebep, sizeof(g_pump.last_sebep) - 1);
  g_pump.last_sebep[sizeof(g_pump.last_sebep) - 1] = '\0';

  digitalWrite(PIN_RELAY, PUMP_ON);
  buzzerWateringStart();
  postWateringStarted(durationS, power, sebep, src);
  Serial.printf("[PUMP] başladı: %ds (güç=%.2f, sebep=%s, src=%s)\n",
                durationS, power, sebep, src == SRC_AUTO ? "AUTO" : "MANUAL");
}

void pumpStop() {
  digitalWrite(PIN_RELAY, PUMP_OFF);
  g_pump.active = false;
  postEvent("WATERING_COMPLETED");
  Serial.println("[PUMP] tamamlandı");
}

void pumpTick() {
  if (!g_pump.active) return;
  if (millis() - g_pump.startMs >= (unsigned long)g_pump.durationS * 1000UL) {
    pumpStop();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ALARM SİSTEMİ
// ─────────────────────────────────────────────────────────────────────────────
void checkAlarms(const SensorData& d) {
  auto handle = [&](bool& flag, bool cond, const char* type,
                     float value, float limit, bool beep) {
    if (cond && !flag) {
      flag = true;
      if (beep) buzzerAlarm();
      postAlarmEvent("ALARM_START", type, value, limit);
    } else if (!cond && flag) {
      flag = false;
      postAlarmEvent("ALARM_END", type, value, limit);
    }
  };

  if (d.valid) {
    handle(alarm_temp_low,  d.T  < g_profile.sicaklik_min, "TEMP_LOW",
           d.T,  g_profile.sicaklik_min, true);
    handle(alarm_temp_high, d.T  > g_profile.sicaklik_max, "TEMP_HIGH",
           d.T,  g_profile.sicaklik_max, true);
    handle(alarm_rh_low,    d.RH < g_profile.nem_min,      "RH_LOW",
           d.RH, g_profile.nem_min, false);
    handle(alarm_rh_high,   d.RH > g_profile.nem_max,      "RH_HIGH",
           d.RH, g_profile.nem_max, false);
  }
  if (d.lux_valid) {
    handle(alarm_light_low,  d.lux < g_profile.isik_min, "LIGHT_LOW",
           (float)d.lux, (float)g_profile.isik_min, false);
    handle(alarm_light_high, d.lux > g_profile.isik_max, "LIGHT_HIGH",
           (float)d.lux, (float)g_profile.isik_max, false);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ölçüm Döngüsü — sensör okuması, alarm değerlendirmesi, otomatik sulama
// ─────────────────────────────────────────────────────────────────────────────
void runSensorCycle() {
  SensorData d = readSensors();

  // Profil yoksa kullanıcıyı uyar; veri akışı yine de devam etsin
  if (!g_profile.bitki_secildi) {
    postEvent("NO_PLANT_SELECTED");
  }

  postIngest(d);

  // Profil yoksa kararsal mantığı atla — sadece pasif izleme
  if (!g_profile.bitki_secildi) return;

  checkAlarms(d);

  // Otomatik sulama koşulları
  if (!d.soil_valid)                         return;
  if (g_pump.active)                         return;
  if (d.soil >= g_profile.toprak_kuru_esik)  return;

  // DHT okuması başarısız olduysa konfor aralığının ortasını kullan
  float T_safe = d.valid ? d.T :
                 (g_profile.sicaklik_min + g_profile.sicaklik_max) / 2.0f;

  FuzzyResult r = fuzzy_irrigate_with_reason(d.soil, T_safe);
  if (r.sulama_sure > 0) {
    pumpStart(r.sulama_sure, r.irrigation_power, r.sebep, SRC_AUTO);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WiFi yeniden bağlanma — bloklamadan, belirli aralıklarla yeniden dener
// ─────────────────────────────────────────────────────────────────────────────
void handleWiFiReconnect() {
  if (WiFi.status() == WL_CONNECTED) return;
  if (millis() - lastWiFiAttempt < WIFI_RETRY_INTERVAL) return;
  lastWiFiAttempt = millis();
  Serial.println("[WiFi] yeniden bağlanılıyor...");
  WiFi.disconnect();
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  helloSent = false;   // bağlantı geri gelince /hello yeniden tetiklenir
}

// ─────────────────────────────────────────────────────────────────────────────
// HTTP — Auth Helper
// ─────────────────────────────────────────────────────────────────────────────
bool checkAuth() {
  if (!server.hasHeader("X-Device-Token")) {
    server.send(401, "application/json", "{\"error\":\"missing token\"}");
    return false;
  }
  if (server.header("X-Device-Token") != String(DEVICE_TOKEN)) {
    server.send(401, "application/json", "{\"error\":\"invalid token\"}");
    return false;
  }
  return true;
}

// ─────────────────────────────────────────────────────────────────────────────
// /cmd/set_profile — appten gelen profili kabul et, NVS'e yaz
// ─────────────────────────────────────────────────────────────────────────────
void handleSetProfile() {
  if (!checkAuth()) return;
  if (!server.hasArg("plain")) {
    server.send(400, "application/json", "{\"error\":\"no body\"}");
    return;
  }

  StaticJsonDocument<512> req;
  if (deserializeJson(req, server.arg("plain"))) {
    server.send(400, "application/json", "{\"error\":\"invalid json\"}");
    return;
  }

  // Profil bütünlüğünü garanti altına almak için tüm alanlar zorunlu
  const char* required[] = { "sicaklik_min","sicaklik_max","sicaklik_stres",
                             "nem_min","nem_max","toprak_kuru_esik",
                             "sulama_sure_max","isik_min","isik_max","bitki_adi" };
  for (auto k : required) {
    if (!req.containsKey(k)) {
      server.send(400, "application/json", "{\"error\":\"missing field\"}");
      return;
    }
  }

  g_profile.sicaklik_min     = req["sicaklik_min"].as<float>();
  g_profile.sicaklik_max     = req["sicaklik_max"].as<float>();
  g_profile.sicaklik_stres   = req["sicaklik_stres"].as<float>();
  g_profile.nem_min          = req["nem_min"].as<float>();
  g_profile.nem_max          = req["nem_max"].as<float>();
  g_profile.toprak_kuru_esik = req["toprak_kuru_esik"].as<float>();
  g_profile.sulama_sure_max  = req["sulama_sure_max"].as<int>();
  g_profile.isik_min         = req["isik_min"].as<int>();
  g_profile.isik_max         = req["isik_max"].as<int>();
  strncpy(g_profile.bitki_adi, req["bitki_adi"].as<const char*>(),
          sizeof(g_profile.bitki_adi) - 1);
  g_profile.bitki_adi[sizeof(g_profile.bitki_adi) - 1] = '\0';
  g_profile.bitki_secildi = true;

  // Eşikler değiştiği için alarm geçişlerinin baştan değerlendirilmesi gerek
  alarm_temp_low = alarm_temp_high = false;
  alarm_rh_low   = alarm_rh_high   = false;
  alarm_light_low= alarm_light_high = false;

  profileSave();
  server.send(200, "application/json", "{\"status\":\"ok\"}");
  buzzerProfileUpdated();
  postEvent("PROFILE_UPDATED");
}

// ─────────────────────────────────────────────────────────────────────────────
// /cmd/manual_pump — toprak kontrolüyle manuel sulama
// ─────────────────────────────────────────────────────────────────────────────
void handleManualPump() {
  if (!checkAuth()) return;

  if (g_pump.active) {
    server.send(409, "application/json", "{\"error\":\"pump_busy\"}");
    buzzerRejected();
    postManualPumpRejected("POMPA_MESGUL");
    return;
  }

  SensorData d = readSensors();
  if (!d.soil_valid) {
    server.send(503, "application/json", "{\"error\":\"sensor_invalid\"}");
    return;
  }

  if (d.soil >= g_profile.toprak_kuru_esik) {
    server.send(200, "application/json", "{\"status\":\"rejected\",\"reason\":\"soil_ok\"}");
    buzzerRejected();
    postManualPumpRejected("TOPRAK_YETERLI");
    return;
  }

  // Manuel tetiklemede de süreyi fuzzy belirler — aşırı sulamayı önler.
  float T_safe = d.valid ? d.T :
                 (g_profile.sicaklik_min + g_profile.sicaklik_max) / 2.0f;
  FuzzyResult r = fuzzy_irrigate_with_reason(d.soil, T_safe);
  int sure = r.sulama_sure > 0 ? r.sulama_sure : 1;  // en az 1sn

  server.send(200, "application/json", "{\"status\":\"ok\"}");
  pumpStart(sure, r.irrigation_power, r.sebep, SRC_MANUAL);
}

// ─────────────────────────────────────────────────────────────────────────────
// SETUP
// ─────────────────────────────────────────────────────────────────────────────
void setup() {
  Serial.begin(115200);
  delay(200);
  Serial.println("\n[boot] Smart Pot — başlatılıyor");

  // Donanım pinlerinin başlangıç durumu
  pinMode(PIN_RELAY, OUTPUT);
  digitalWrite(PIN_RELAY, PUMP_OFF);
  buzzerInit();

  // Sensörler
  dht.begin();
  Wire.begin(PIN_SDA, PIN_SCL);
  lightMeter.begin();

  // Profili kalıcı bellekten yükle (yoksa default kullanılır)
  profileLoad();

  // WiFi
  Serial.printf("[WiFi] bağlanıyor: %s\n", WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  unsigned long wifiStart = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - wifiStart < 20000UL) {
    delay(500);
    Serial.print(".");
  }
  if (WiFi.status() == WL_CONNECTED) {
    Serial.printf("\n[WiFi] bağlandı: %s\n", WiFi.localIP().toString().c_str());
  } else {
    Serial.println("\n[WiFi] timeout — loop'ta tekrar denenecek");
  }

  // HTTP server — komut endpointleri
  static const char* kCollectedHeaders[] = { "X-Device-Token" };
  server.collectHeaders(kCollectedHeaders, 1);
  server.on("/cmd/set_profile", HTTP_POST, handleSetProfile);
  server.on("/cmd/manual_pump", HTTP_POST, handleManualPump);
  server.begin();
  Serial.println("[HTTP] server hazır (port 80)");

  // Açılış handshake'i ve melodisi
  if (WiFi.status() == WL_CONNECTED) postHello();
  buzzerBoot();

  // İlk ölçümü gecikmesiz tetiklemek için zamanlayıcıyı geriye al
  lastSensorTime = millis() - LOOP_INTERVAL_MS;
}

// ─────────────────────────────────────────────────────────────────────────────
// Ana Döngü — tam non-blocking
// ─────────────────────────────────────────────────────────────────────────────
void loop() {
  handleWiFiReconnect();
  server.handleClient();
  pumpTick();

  // /hello başarısız kaldıysa periyodik olarak yeniden dene
  if (!helloSent && WiFi.status() == WL_CONNECTED &&
      millis() - lastHelloTime > HELLO_RETRY_MS) {
    postHello();
  }

  // Periyodik ölçüm + heartbeat
  if (millis() - lastSensorTime >= LOOP_INTERVAL_MS) {
    lastSensorTime = millis();
    runSensorCycle();
  }

  delay(10);   // WiFi yığınına nefes aldır
}

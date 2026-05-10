#pragma once
#include <Arduino.h>
#include "config.h"

// ─────────────────────────────────────────────────────────────────────────────
// Buzzer kontrolü — ESP32 Arduino Core 3.x ledc API'si üzerinden çalışır.
// Arduino'nun standart tone() fonksiyonu ESP32'de timer çakışmasına yol açtığı
// için ledc kullanılır. Yeni API'de ledcAttach() pin'e doğrudan kanal bağlar
// ve ledcWriteTone() istenen frekansta ton üretir.
//
// Tüm yardımcılar kısa süreli (≤ 600ms) bloklar; sadece durum geçişlerinde
// (boot, profil güncellendi, sulama başladı, alarm vb.) çağrılır — periyodik
// döngüde kullanılmamalıdır.
// ─────────────────────────────────────────────────────────────────────────────

inline void buzzerInit() {
  ledcAttach(PIN_BUZZER, BUZZER_LEDC_FREQ, BUZZER_LEDC_RES);
  ledcWrite(PIN_BUZZER, 0);
}

inline void buzzerTone(int freq, int durationMs) {
  ledcWriteTone(PIN_BUZZER, freq);
  delay(durationMs);
  ledcWriteTone(PIN_BUZZER, 0);
}

// ── Sembolik Sesler ──────────────────────────────────────────────────────────

/// Sıcaklık alarmı — kritik durumda dikkat çekici tek beep.
inline void buzzerAlarm() {
  buzzerTone(1000, 200);
}

/// Açılış melodisi — yükselen üç notalı kısa intro (C5 → E5 → G5).
inline void buzzerBoot() {
  buzzerTone(523, 100);
  delay(40);
  buzzerTone(659, 100);
  delay(40);
  buzzerTone(784, 150);
}

/// Profil güncellendi onayı — tek kısa nota (A5).
inline void buzzerProfileUpdated() {
  buzzerTone(880, 120);
}

/// Sulama başladığında çalan kısa orta ton.
inline void buzzerWateringStart() {
  buzzerTone(700, 100);
}

/// Manuel sulama isteği reddedildiğinde çalan iki kademeli düşük ton.
inline void buzzerRejected() {
  buzzerTone(300, 80);
  delay(40);
  buzzerTone(220, 120);
}

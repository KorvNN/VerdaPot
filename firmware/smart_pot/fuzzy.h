#pragma once
#include <Arduino.h>

// ─────────────────────────────────────────────────────────────────────────────
// Aktif Profil — appten /cmd/set_profile ile gelir, NVS'te saklanır.
// Tüm fuzzy hesabı bu struct üzerinden yapılır.
// ─────────────────────────────────────────────────────────────────────────────
struct ActiveProfile {
  float sicaklik_min;
  float sicaklik_max;
  float sicaklik_stres;     // fuzzy stres marjı (°C)
  float nem_min;
  float nem_max;
  float toprak_kuru_esik;   // bu altına düşünce sulama düşünülür (%)
  int   sulama_sure_max;    // fuzzy bunun yüzdesi kadar sular (sn)
  int   isik_min;
  int   isik_max;
  char  bitki_adi[32];
  bool  bitki_secildi;      // false ise NO_PLANT_SELECTED gönderilir
};

// Aktif profilin global örneği. smart_pot.ino içinde tanımlıdır.
extern ActiveProfile g_profile;

// ─────────────────────────────────────────────────────────────────────────────
// Fuzzy çıktısı: süre, güç ve baskın kuralın açıklaması bir arada.
// ─────────────────────────────────────────────────────────────────────────────
struct FuzzyResult {
  int   sulama_sure;       // saniye (0 → sulama yok)
  float irrigation_power;  // 0.0 – 1.0
  char  sebep[64];         // baskın olan fuzzy kuralının açıklaması
};


inline float trapezoid(float x, float a, float b, float c, float d) {
  if (x < a || x > d) return 0.0f;
  if (x < b) return (b == a) ? 1.0f : (x - a) / (b - a);
  if (x <= c) return 1.0f;
  return (d == c) ? 1.0f : (d - x) / (d - c);
}

// ─────────────────────────────────────────────────────────────────────────────
// Toprak Nemi Üyelik (eşik = g_profile.toprak_kuru_esik)
// ─────────────────────────────────────────────────────────────────────────────
struct SoilMembership { float kuru, nemli, islak; };

inline SoilMembership fuzzify_soil(float soil) {
  const float rt = g_profile.toprak_kuru_esik;
  SoilMembership m;
  m.kuru  = trapezoid(soil,  0.0f,        0.0f,       rt - 10.0f, rt);
  m.nemli = trapezoid(soil,  rt - 10.0f,  rt,         rt + 20.0f, rt + 30.0f);
  m.islak = trapezoid(soil,  rt + 20.0f,  rt + 30.0f, 100.0f,     100.0f);
  return m;
}

// ─────────────────────────────────────────────────────────────────────────────
// Sıcaklık Stresi Üyelik
// ─────────────────────────────────────────────────────────────────────────────
struct TempMembership { float stres_soguk, normal, stres_sicak; };

inline TempMembership fuzzify_temp(float T) {
  const float t_min   = g_profile.sicaklik_min;
  const float t_max   = g_profile.sicaklik_max;
  const float t_stres = g_profile.sicaklik_stres;
  TempMembership m;
  m.stres_soguk = trapezoid(T, -99.0f,         -99.0f,
                                t_min,           t_min + t_stres);
  m.normal      = trapezoid(T,  t_min,           t_min + t_stres,
                                t_max - t_stres, t_max);
  m.stres_sicak = trapezoid(T,  t_max - t_stres, t_max,
                                99.0f,           99.0f);
  return m;
}

// ─────────────────────────────────────────────────────────────────────────────
// Kural Tabanı — MIN-MAX inference
// 4 aktif kural baskın çıktıyı üretir; geri kalan kombinasyonlar (nemli+normal,
// islak+her durum, vs.) sulamayı tetiklemez. Ağırlıklar muhafazakâr seçilmiştir
// — 33 ml/sn debili pompada aşırı sulama riskini düşürür.
// ─────────────────────────────────────────────────────────────────────────────
struct RuleResult {
  float power;
  const char* sebep;
};

inline RuleResult run_rules(const SoilMembership& s, const TempMembership& t) {
  const float k1 = min(s.kuru,  t.stres_sicak);            // kuru + sıcak → tam güç
  const float k2 = min(s.kuru,  t.normal)       * 0.7f;    // kuru + normal
  const float k3 = min(s.kuru,  t.stres_soguk)  * 0.4f;    // kuru + soğuk
  const float k4 = min(s.nemli, t.stres_sicak)  * 0.3f;    // nemli + sıcak

  float       best  = k1;
  const char* sebep = "toprak_kuru + sicaklik_stres";

  if (k2 > best) { best = k2; sebep = "toprak_kuru + sicaklik_normal"; }
  if (k3 > best) { best = k3; sebep = "toprak_kuru + sicaklik_dusuk"; }
  if (k4 > best) { best = k4; sebep = "toprak_nemli + sicaklik_yuksek"; }

  if (best <= 0.0f) sebep = "sulama_gerekmez";
  return { best, sebep };
}

// ─────────────────────────────────────────────────────────────────────────────
// Defuzzification — irrigation_power × sulama_sure_max
// ─────────────────────────────────────────────────────────────────────────────
inline int defuzzify(float power, int sure_max) {
  return (int)round(power * (float)sure_max);
}

// ─────────────────────────────────────────────────────────────────────────────
// Sulama Kararı — süre, güç ve gerekçeyi tek seferde döndürür.
// ─────────────────────────────────────────────────────────────────────────────
inline FuzzyResult fuzzy_irrigate_with_reason(float soil, float T) {
  FuzzyResult r;
  SoilMembership s = fuzzify_soil(soil);
  TempMembership t = fuzzify_temp(T);
  RuleResult     rr = run_rules(s, t);

  r.irrigation_power = rr.power;
  r.sulama_sure      = defuzzify(rr.power, g_profile.sulama_sure_max);
  strncpy(r.sebep, rr.sebep, sizeof(r.sebep) - 1);
  r.sebep[sizeof(r.sebep) - 1] = '\0';
  return r;
}

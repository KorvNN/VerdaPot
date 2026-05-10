import 'package:drift/drift.dart';

import '../database.dart';

/// İlk açılışta 15 preset bitkiyi veritabanına yükler. Idempotent — tablo
/// boş değilse hiçbir şey yapmaz, sonraki açılışlarda güvenle tekrar çağrılır.
///
/// Bitkiler üç sıcaklık grubuna (cool / medium / warm) ayrılır; her grup ortak
/// sıcaklık ve nem aralıklarını paylaşır. Toprak eşiği gruptaki ortak değere
/// her bitkinin kendi offsetinin eklenmesiyle hesaplanır.
class Seeder {
  Seeder(this._db);
  final AppDatabase _db;

  Future<void> run() async {
    final existing = await _db.select(_db.plantProfiles).get();
    if (existing.isNotEmpty) return;

    await _db.batch((b) {
      b.insertAll(_db.plantProfiles, _presets());
    });
  }

  // ── Sıcaklık Grupları ──────────────────────────────────────────────────────
  // Cool — serin iklim bitkileri
  static const _coolTMin = 10.0, _coolTMax = 18.0, _coolStres = 3.0;
  static const _coolRhMin = 40.0, _coolRhMax = 60.0, _coolBaseSoil = 35.0;
  // Medium — orta iklim bitkileri
  static const _medTMin = 18.0, _medTMax = 24.0, _medStres = 4.0;
  static const _medRhMin = 50.0, _medRhMax = 70.0, _medBaseSoil = 45.0;
  // Warm — sıcak iklim bitkileri
  static const _warmTMin = 22.0, _warmTMax = 30.0, _warmStres = 5.0;
  static const _warmRhMin = 60.0, _warmRhMax = 80.0, _warmBaseSoil = 50.0;

  List<PlantProfilesCompanion> _presets() => [
        // ── COOL (5) ──────────────────────────────────────────────────────
        _make(en: 'Ivy',           tr: 'Sarmaşık',
              tMin: _coolTMin, tMax: _coolTMax, stres: _coolStres,
              rhMin: _coolRhMin, rhMax: _coolRhMax,
              kuruEsik: _coolBaseSoil + 0,    sureMax: 3,
              luxMin: 1614, luxMax: 10764),
        _make(en: 'Hydrangea',     tr: 'Ortanca',
              tMin: _coolTMin, tMax: _coolTMax, stres: _coolStres,
              rhMin: _coolRhMin, rhMax: _coolRhMax,
              kuruEsik: _coolBaseSoil + 12,   sureMax: 6,
              luxMin: 807,  luxMax: 10764),
        _make(en: 'Jasmine',       tr: 'Yasemin',
              tMin: _coolTMin, tMax: _coolTMax, stres: _coolStres,
              rhMin: _coolRhMin, rhMax: _coolRhMax,
              kuruEsik: _coolBaseSoil - 8,    sureMax: 2,
              luxMin: 1614, luxMax: 10764),
        _make(en: 'Chrysanthemum', tr: 'Kasımpatı',
              tMin: _coolTMin, tMax: _coolTMax, stres: _coolStres,
              rhMin: _coolRhMin, rhMax: _coolRhMax,
              kuruEsik: _coolBaseSoil + 0,    sureMax: 3,
              luxMin: 1614, luxMax: 10764),
        _make(en: 'Camellia',      tr: 'Kamelya',
              tMin: _coolTMin, tMax: _coolTMax, stres: _coolStres,
              rhMin: _coolRhMin, rhMax: _coolRhMax,
              kuruEsik: _coolBaseSoil + 5,    sureMax: 4,
              luxMin: 807,  luxMax: 10764),

        // ── MEDIUM (5) ────────────────────────────────────────────────────
        _make(en: 'Monstera',      tr: 'Monstera',
              tMin: _medTMin, tMax: _medTMax, stres: _medStres,
              rhMin: _medRhMin, rhMax: _medRhMax,
              kuruEsik: _medBaseSoil + 5,     sureMax: 5,
              luxMin: 807,  luxMax: 10764, isActive: true),  // ilk açılış aktif bitkisi
        _make(en: 'Sansevieria',   tr: 'Yılan Bitkisi',
              tMin: _medTMin, tMax: _medTMax, stres: _medStres,
              rhMin: _medRhMin, rhMax: _medRhMax,
              kuruEsik: _medBaseSoil - 12,    sureMax: 2,
              luxMin: 270,  luxMax: 10764),
        _make(en: 'Cactus',        tr: 'Kaktüs',
              tMin: _medTMin, tMax: _medTMax, stres: _medStres,
              rhMin: _medRhMin, rhMax: _medRhMax,
              kuruEsik: _medBaseSoil - 15,    sureMax: 2,
              luxMin: 10764, luxMax: 99999),
        _make(en: 'Begonia',       tr: 'Begonya',
              tMin: _medTMin, tMax: _medTMax, stres: _medStres,
              rhMin: _medRhMin, rhMax: _medRhMax,
              kuruEsik: _medBaseSoil + 10,    sureMax: 6,
              luxMin: 10764, luxMax: 99999),
        _make(en: 'Ficus',         tr: 'Fikus',
              tMin: _medTMin, tMax: _medTMax, stres: _medStres,
              rhMin: _medRhMin, rhMax: _medRhMax,
              kuruEsik: _medBaseSoil + 0,     sureMax: 4,
              luxMin: 807,  luxMax: 10764),

        // ── WARM (5) ──────────────────────────────────────────────────────
        _make(en: 'Peace Lily',    tr: 'Barış Çiçeği',
              tMin: _warmTMin, tMax: _warmTMax, stres: _warmStres,
              rhMin: _warmRhMin, rhMax: _warmRhMax,
              kuruEsik: _warmBaseSoil + 10,   sureMax: 7,
              luxMin: 270,  luxMax: 1614),
        _make(en: 'Pothos',        tr: 'Pothos',
              tMin: _warmTMin, tMax: _warmTMax, stres: _warmStres,
              rhMin: _warmRhMin, rhMax: _warmRhMax,
              kuruEsik: _warmBaseSoil - 5,    sureMax: 4,
              luxMin: 270,  luxMax: 10764),
        _make(en: 'Dracaena',      tr: 'Drasen',
              tMin: _warmTMin, tMax: _warmTMax, stres: _warmStres,
              rhMin: _warmRhMin, rhMax: _warmRhMax,
              kuruEsik: _warmBaseSoil - 8,    sureMax: 3,
              luxMin: 807,  luxMax: 10764),
        _make(en: 'Calathea',      tr: 'Kalatea',
              tMin: _warmTMin, tMax: _warmTMax, stres: _warmStres,
              rhMin: _warmRhMin, rhMax: _warmRhMax,
              kuruEsik: _warmBaseSoil + 12,   sureMax: 7,
              luxMin: 270,  luxMax: 807),
        _make(en: 'African Violet', tr: 'Afrika Menekşesi',
              tMin: _warmTMin, tMax: _warmTMax, stres: _warmStres,
              rhMin: _warmRhMin, rhMax: _warmRhMax,
              kuruEsik: _warmBaseSoil + 0,    sureMax: 5,
              luxMin: 807,  luxMax: 1614),
      ];

  PlantProfilesCompanion _make({
    required String en,
    required String tr,
    required double tMin,
    required double tMax,
    required double stres,
    required double rhMin,
    required double rhMax,
    required double kuruEsik,
    required int sureMax,
    required int luxMin,
    required int luxMax,
    bool isActive = false,
  }) {
    return PlantProfilesCompanion(
      bitkiAdi:        Value(en),
      bitkiAdiTr:      Value(tr),
      sicaklikMin:     Value(tMin),
      sicaklikMax:     Value(tMax),
      sicaklikStres:   Value(stres),
      nemMin:          Value(rhMin),
      nemMax:          Value(rhMax),
      toprakKuruEsik:  Value(kuruEsik),
      sulamaSureMax:   Value(sureMax),
      isikMin:         Value(luxMin),
      isikMax:         Value(luxMax),
      isPreset:        const Value(true),
      isActive:        Value(isActive),
    );
  }
}

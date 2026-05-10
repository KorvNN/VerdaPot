import 'package:drift/drift.dart';

import '../database.dart';

/// Bitki profilleri tablosu için CRUD katmanı ve aktif profil işlemleri.
class ProfileRepo {
  ProfileRepo(this._db);
  final AppDatabase _db;

  /// Tüm bitkileri reaktif olarak izler (önce preset'ler, sonra ada göre).
  Stream<List<PlantProfile>> watchAll() {
    return (_db.select(_db.plantProfiles)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isPreset, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.bitkiAdi),
          ]))
        .watch();
  }

  /// Aktif bitkiyi izler (aynı anda en fazla bir tane aktif olabilir).
  Stream<PlantProfile?> watchActive() {
    return (_db.select(_db.plantProfiles)
          ..where((t) => t.isActive.equals(true))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<PlantProfile?> getActive() {
    return (_db.select(_db.plantProfiles)
          ..where((t) => t.isActive.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  /// Tek transaction'da: tüm satırları pasifleştir, sonra hedef satırı aktive et.
  Future<void> activate(int id) async {
    await _db.transaction(() async {
      await (_db.update(_db.plantProfiles))
          .write(const PlantProfilesCompanion(isActive: Value(false)));
      await (_db.update(_db.plantProfiles)..where((t) => t.id.equals(id)))
          .write(const PlantProfilesCompanion(isActive: Value(true)));
    });
  }

  /// Kullanıcı tarafından girilmiş özel bir bitkiyi ekler. Pasif olarak başlar.
  Future<int> insertCustom(PlantProfilesCompanion entry) {
    return _db.into(_db.plantProfiles).insert(entry.copyWith(
          isPreset: const Value(false),
          isActive: const Value(false),
        ));
  }

  Future<int> deleteById(int id) {
    return (_db.delete(_db.plantProfiles)..where((t) => t.id.equals(id))).go();
  }

}

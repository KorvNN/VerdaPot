import 'package:drift/drift.dart';

import '../database.dart';

class SensorReadingRepo {
  SensorReadingRepo(this._db);
  final AppDatabase _db;

  Future<int> insert(SensorReadingsCompanion entry) {
    return _db.into(_db.sensorReadings).insert(entry);
  }

  Stream<SensorReading?> watchLatest(int deviceId) {
    return (_db.select(_db.sensorReadings)
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([(t) => OrderingTerm.desc(t.ts)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<SensorReading?> getLatest(int deviceId) {
    return (_db.select(_db.sensorReadings)
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([(t) => OrderingTerm.desc(t.ts)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<SensorReading>> queryWindow({
    required int deviceId,
    required int fromTsMs,
    required int toTsMs,
  }) {
    return (_db.select(_db.sensorReadings)
          ..where((t) =>
              t.deviceId.equals(deviceId) &
              t.ts.isBetweenValues(fromTsMs, toTsMs))
          ..orderBy([(t) => OrderingTerm(expression: t.ts)]))
        .get();
  }

  Future<List<SensorReading>> last24h(int deviceId, {DateTime? now}) {
    final end = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return queryWindow(
      deviceId: deviceId,
      fromTsMs: end - const Duration(hours: 24).inMilliseconds,
      toTsMs: end,
    );
  }

  Future<List<SensorReading>> last7d(int deviceId, {DateTime? now}) {
    final end = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return queryWindow(
      deviceId: deviceId,
      fromTsMs: end - const Duration(days: 7).inMilliseconds,
      toTsMs: end,
    );
  }

  Future<List<SensorReading>> last30d(int deviceId, {DateTime? now}) {
    final end = (now ?? DateTime.now()).millisecondsSinceEpoch;
    return queryWindow(
      deviceId: deviceId,
      fromTsMs: end - const Duration(days: 30).inMilliseconds,
      toTsMs: end,
    );
  }

  Future<int> pruneOlderThan(int cutoffTsMs) {
    return (_db.delete(_db.sensorReadings)
          ..where((t) => t.ts.isSmallerThanValue(cutoffTsMs)))
        .go();
  }
}

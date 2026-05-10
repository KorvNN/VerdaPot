import 'package:drift/drift.dart';

import '../database.dart';

class EventRepo {
  EventRepo(this._db);
  final AppDatabase _db;

  Future<int> insert(EventsCompanion entry) {
    return _db.into(_db.events).insert(entry);
  }

  Stream<List<Event>> watchRecent(int deviceId, {int limit = 50}) {
    return (_db.select(_db.events)
          ..where((t) => t.deviceId.equals(deviceId))
          ..orderBy([(t) => OrderingTerm.desc(t.ts)])
          ..limit(limit))
        .watch();
  }

  Future<Event?> getMostRecentOfKind(int deviceId, String kind) {
    return (_db.select(_db.events)
          ..where((t) => t.deviceId.equals(deviceId) & t.kind.equals(kind))
          ..orderBy([(t) => OrderingTerm.desc(t.ts)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Event>> queryWindow({
    required int deviceId,
    required int fromTsMs,
    required int toTsMs,
  }) {
    return (_db.select(_db.events)
          ..where((t) =>
              t.deviceId.equals(deviceId) &
              t.ts.isBetweenValues(fromTsMs, toTsMs))
          ..orderBy([(t) => OrderingTerm.desc(t.ts)]))
        .get();
  }
}

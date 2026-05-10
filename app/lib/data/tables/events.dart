import 'package:drift/drift.dart';

import 'devices.dart';

@TableIndex(name: 'idx_events_device_ts', columns: {#deviceId, #ts})
@TableIndex(name: 'idx_events_ts', columns: {#ts})
@TableIndex(name: 'idx_events_kind', columns: {#kind})
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deviceId => integer().references(Devices, #id)();
  IntColumn get ts => integer()();
  TextColumn get kind => text()();
  TextColumn get payload => text().nullable()();
}

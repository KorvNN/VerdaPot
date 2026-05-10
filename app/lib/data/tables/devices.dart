import 'package:drift/drift.dart';

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get mac => text().nullable()();
  TextColumn get token => text().nullable()();
  IntColumn get lastSeenAt => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

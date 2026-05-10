import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/devices.dart';
import 'tables/events.dart';
import 'tables/plant_profiles.dart';
import 'tables/sensor_readings.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Devices,
  SensorReadings,
  Events,
  PlantProfiles,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'smart_pot'));

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

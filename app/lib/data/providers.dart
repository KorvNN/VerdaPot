import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';
import 'repositories/device_repo.dart';
import 'repositories/event_repo.dart';
import 'repositories/profile_repo.dart';
import 'repositories/sensor_reading_repo.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden in main()');
});

final deviceRepoProvider = Provider<DeviceRepo>((ref) {
  return DeviceRepo(ref.watch(databaseProvider));
});

final sensorReadingRepoProvider = Provider<SensorReadingRepo>((ref) {
  return SensorReadingRepo(ref.watch(databaseProvider));
});

final eventRepoProvider = Provider<EventRepo>((ref) {
  return EventRepo(ref.watch(databaseProvider));
});

final profileRepoProvider = Provider<ProfileRepo>((ref) {
  return ProfileRepo(ref.watch(databaseProvider));
});

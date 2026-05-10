import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';

final activeDeviceProvider = StreamProvider<Device?>((ref) {
  return ref.watch(deviceRepoProvider).watchActive();
});

final latestReadingProvider = StreamProvider<SensorReading?>((ref) {
  final device = ref.watch(activeDeviceProvider).asData?.value;
  if (device == null) return Stream.value(null);
  return ref.watch(sensorReadingRepoProvider).watchLatest(device.id);
});

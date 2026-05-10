import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard/providers.dart';
import '../data/database.dart';
import '../data/providers.dart';
import 'time_window.dart';

class SelectedWindowNotifier extends Notifier<TimeWindow> {
  @override
  TimeWindow build() => TimeWindow.last24h;

  void set(TimeWindow value) => state = value;
}

final selectedWindowProvider =
    NotifierProvider<SelectedWindowNotifier, TimeWindow>(
        SelectedWindowNotifier.new);

final historyReadingsProvider =
    FutureProvider<List<SensorReading>>((ref) async {
  final device = ref.watch(activeDeviceProvider).asData?.value;
  if (device == null) return const [];
  final window = ref.watch(selectedWindowProvider);
  final repo = ref.watch(sensorReadingRepoProvider);
  final now = DateTime.now().millisecondsSinceEpoch;
  return repo.queryWindow(
    deviceId: device.id,
    fromTsMs: now - window.duration.inMilliseconds,
    toTsMs: now,
  );
});

import '../data/database.dart';

/// Splits a chronologically-ordered list of readings into contiguous runs.
/// A gap larger than [maxGap] starts a new run.
///
/// Returns an empty list when [readings] is empty.
/// Returns a single-element list when no gaps exceed [maxGap].
List<List<SensorReading>> splitReadingsByGap(
  List<SensorReading> readings, {
  required Duration maxGap,
}) {
  if (readings.isEmpty) return const [];

  final gapMs = maxGap.inMilliseconds;
  final runs = <List<SensorReading>>[];
  var current = <SensorReading>[readings.first];

  for (var i = 1; i < readings.length; i++) {
    final delta = readings[i].ts - readings[i - 1].ts;
    if (delta > gapMs) {
      runs.add(current);
      current = <SensorReading>[];
    }
    current.add(readings[i]);
  }
  runs.add(current);
  return runs;
}

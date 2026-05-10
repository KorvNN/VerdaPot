import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../data/database.dart';

/// Sensor okumalarını CSV olarak biçimlendirir.
String formatReadingsAsCsv(List<SensorReading> readings) {
  final buf = StringBuffer()
    ..writeln('ts_ms,iso8601_utc,temperature_c,humidity_pct,soil_moisture,'
              'light_lux,pump_active,bitki_adi');
  for (final r in readings) {
    buf
      ..write(r.ts)
      ..write(',')
      ..write(DateTime.fromMillisecondsSinceEpoch(r.ts, isUtc: true)
          .toIso8601String())
      ..write(',')
      ..write(r.temperatureC ?? '')
      ..write(',')
      ..write(r.humidityPct ?? '')
      ..write(',')
      ..write(r.soilMoisture ?? '')
      ..write(',')
      ..write(r.lightLux ?? '')
      ..write(',')
      ..write(r.pumpActive)
      ..write(',')
      ..writeln(_csvEscape(r.bitkiAdi ?? ''));
  }
  return buf.toString();
}

String _csvEscape(String s) {
  if (s.contains(',') || s.contains('"') || s.contains('\n')) {
    return '"${s.replaceAll('"', '""')}"';
  }
  return s;
}

Future<String> exportReadingsToCsvFile(List<SensorReading> readings) async {
  final dir = await getApplicationDocumentsDirectory();
  final stamp = DateTime.now()
      .toIso8601String()
      .replaceAll(':', '-')
      .split('.')
      .first;
  final file = File('${dir.path}/smart_pot_history_$stamp.csv');
  await file.writeAsString(formatReadingsAsCsv(readings));
  return file.path;
}

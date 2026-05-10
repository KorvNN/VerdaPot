import 'package:drift/drift.dart';

import 'devices.dart';

/// ESP32'den gelen periyodik /ingest paketlerinin saklandığı tablo.
@TableIndex(name: 'idx_readings_device_ts', columns: {#deviceId, #ts})
@TableIndex(name: 'idx_readings_ts', columns: {#ts})
class SensorReadings extends Table {
  IntColumn  get id            => integer().autoIncrement()();
  IntColumn  get deviceId      => integer().references(Devices, #id)();
  IntColumn  get ts            => integer()();
  RealColumn get temperatureC  => real().nullable()();
  RealColumn get humidityPct   => real().nullable()();
  IntColumn  get soilMoisture  => integer().nullable()();
  IntColumn  get lightLux      => integer().nullable()();
  BoolColumn get pumpActive    => boolean().withDefault(const Constant(false))();
  TextColumn get bitkiAdi      => text().nullable()();   // ESP32'nin aktif bitkisi
}

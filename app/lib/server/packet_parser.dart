import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/database.dart';

class PacketException implements Exception {
  PacketException(this.message);
  final String message;
  @override
  String toString() => 'PacketException: $message';
}

/// /ingest paketini bir SensorReadings satırına dönüştürür.
///
/// Tüm sensör alanları opsiyoneldir — herhangi bir sensör tek başına başarısız
/// olabilir ve cihaz yine de elinde olanı gönderebilir.
///
/// Beklenen alanlar:
///   sicaklik_c (double)   → temperatureC
///   nem_yuzde  (double)   → humidityPct
///   toprak_nem (int)      → soilMoisture
///   isik_lux   (int)      → lightLux
///   pompa_aktif(bool)     → pumpActive
///   bitki_adi  (string)   → bitkiAdi
SensorReadingsCompanion parseSensorPacket(
  Map<String, dynamic> body, {
  required int deviceId,
  DateTime? receivedAt,
}) {
  final ts = (receivedAt ?? DateTime.now()).millisecondsSinceEpoch;
  return SensorReadingsCompanion(
    deviceId:     Value(deviceId),
    ts:           Value(ts),
    temperatureC: _optionalDouble(body, 'sicaklik_c'),
    humidityPct:  _optionalDouble(body, 'nem_yuzde'),
    soilMoisture: _optionalInt(body, 'toprak_nem'),
    lightLux:     _optionalInt(body, 'isik_lux'),
    pumpActive:   _optionalBool(body, 'pompa_aktif'),
    bitkiAdi:     _optionalString(body, 'bitki_adi'),
  );
}

/// /event paketini bir Events satırına dönüştürür.
///
/// Tanınan event türleri:
///   WATERING_STARTED        {sulama_sure, irrigation_power, sebep, tetikleyici}
///   WATERING_COMPLETED
///   ALARM_START / ALARM_END {type, value, limit}
///   NO_PLANT_SELECTED
///   DEVICE_ONLINE
///   PROFILE_UPDATED
///   MANUAL_PUMP_REJECTED    {sebep}
///
/// "kind" dışındaki tüm alanlar JSON string olarak `payload` sütununa yazılır.
EventsCompanion parseEventPacket(
  Map<String, dynamic> body, {
  required int deviceId,
  DateTime? receivedAt,
}) {
  final kind = body['kind'];
  if (kind is! String || kind.isEmpty) {
    throw PacketException('event "kind" gerekli');
  }
  final ts = (receivedAt ?? DateTime.now()).millisecondsSinceEpoch;

  // "kind" dışındaki tüm alanlar payload haline getirilir
  final payloadMap = Map<String, dynamic>.from(body)..remove('kind');
  final payload = payloadMap.isEmpty ? null : jsonEncode(payloadMap);

  return EventsCompanion(
    deviceId: Value(deviceId),
    ts:       Value(ts),
    kind:     Value(kind),
    payload:  payload == null ? const Value.absent() : Value(payload),
  );
}

Value<double?> _optionalDouble(Map<String, dynamic> body, String key) {
  if (!body.containsKey(key) || body[key] == null) return const Value.absent();
  final v = body[key];
  if (v is num) return Value(v.toDouble());
  throw PacketException('"$key" sayı olmalı');
}

Value<int?> _optionalInt(Map<String, dynamic> body, String key) {
  if (!body.containsKey(key) || body[key] == null) return const Value.absent();
  final v = body[key];
  if (v is num) return Value(v.toInt());
  throw PacketException('"$key" sayı olmalı');
}

Value<bool> _optionalBool(Map<String, dynamic> body, String key) {
  if (!body.containsKey(key) || body[key] == null) return const Value.absent();
  final v = body[key];
  if (v is bool) return Value(v);
  throw PacketException('"$key" boolean olmalı');
}

Value<String?> _optionalString(Map<String, dynamic> body, String key) {
  if (!body.containsKey(key) || body[key] == null) return const Value.absent();
  final v = body[key];
  if (v is String) return Value(v);
  throw PacketException('"$key" string olmalı');
}

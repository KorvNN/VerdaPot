import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../data/repositories/device_repo.dart';
import '../data/repositories/event_repo.dart';
import '../data/repositories/sensor_reading_repo.dart';
import 'packet_parser.dart';

/// Gömülü HTTP sunucusunun rota tablosunu kurar.
///
/// Rotalar:
///   POST /ingest  — periyodik sensör paketi
///   POST /event   — anlık olay bildirimi (sulama, alarm, vb.)
///   POST /hello   — açılış handshake'i; device.last_seen_at güncellenir
///   GET  /health  — token doğrulamasından muaf canlılık kontrolü
///
/// Her yazma yolu aktif cihazı her istek başında yeniden okur; bu sayede
/// aktif cihaz değiştirildiğinde değişiklik anında etkili olur.
Handler buildIngestRouter({
  required DeviceRepo deviceRepo,
  required SensorReadingRepo sensorRepo,
  required EventRepo eventRepo,
}) {
  final router = Router();

  router.get('/health', (Request request) {
    return Response.ok(
      jsonEncode({
        'status': 'ok',
        'server_time': DateTime.now().toUtc().toIso8601String(),
      }),
      headers: _jsonHeaders,
    );
  });

  router.post('/ingest', (Request request) async {
    final device = await deviceRepo.getActive();
    if (device == null) {
      return Response(503, body: 'no active device — pair first');
    }
    final body = await _decodeJsonBody(request);
    if (body == null) {
      return Response(400, body: 'request body must be a JSON object');
    }
    try {
      final companion = parseSensorPacket(body, deviceId: device.id);
      final id = await sensorRepo.insert(companion);
      await deviceRepo.updateLastSeen(
        device.id,
        DateTime.now().millisecondsSinceEpoch,
      );
      return Response.ok(jsonEncode({'id': id}), headers: _jsonHeaders);
    } on PacketException catch (e) {
      return Response(400, body: e.message);
    }
  });

  router.post('/event', (Request request) async {
    final device = await deviceRepo.getActive();
    if (device == null) {
      return Response(503, body: 'no active device — pair first');
    }
    final body = await _decodeJsonBody(request);
    if (body == null) {
      return Response(400, body: 'request body must be a JSON object');
    }
    try {
      final companion = parseEventPacket(body, deviceId: device.id);
      final id = await eventRepo.insert(companion);
      await deviceRepo.updateLastSeen(
        device.id,
        DateTime.now().millisecondsSinceEpoch,
      );
      return Response.ok(jsonEncode({'id': id}), headers: _jsonHeaders);
    } on PacketException catch (e) {
      return Response(400, body: e.message);
    }
  });

  router.post('/hello', (Request request) async {
    final device = await deviceRepo.getActive();
    if (device == null) {
      return Response(503, body: 'no active device — pair first');
    }
    await deviceRepo.updateLastSeen(
      device.id,
      DateTime.now().millisecondsSinceEpoch,
    );
    return Response.ok(
      jsonEncode({
        'device_id': device.id,
        'name': device.name,
        'server_time': DateTime.now().toUtc().toIso8601String(),
      }),
      headers: _jsonHeaders,
    );
  });

  return router.call;
}

const Map<String, String> _jsonHeaders = {
  'content-type': 'application/json; charset=utf-8',
};

Future<Map<String, dynamic>?> _decodeJsonBody(Request request) async {
  try {
    final raw = await request.readAsString();
    if (raw.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return null;
  } on FormatException {
    return null;
  }
}

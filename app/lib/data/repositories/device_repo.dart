import 'dart:math';

import 'package:drift/drift.dart';

import '../database.dart';

String generateDeviceToken({Random? rng}) {
  final r = rng ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => r.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

class DeviceRepo {
  DeviceRepo(this._db);
  final AppDatabase _db;

  Future<Device> ensureDefault() async {
    final existing = await _db.select(_db.devices).get();
    if (existing.isNotEmpty) {
      final active = existing.firstWhere(
        (d) => d.isActive,
        orElse: () => existing.first,
      );
      if (active.token == null) {
        await setToken(active.id, generateDeviceToken());
        return (_db.select(_db.devices)..where((t) => t.id.equals(active.id)))
            .getSingle();
      }
      return active;
    }
    final id = await _db.into(_db.devices).insert(
          DevicesCompanion.insert(
            name: 'Smart Pot',
            token: Value(generateDeviceToken()),
          ),
        );
    return (_db.select(_db.devices)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<String> regenerateToken(int deviceId) async {
    final token = generateDeviceToken();
    await setToken(deviceId, token);
    return token;
  }

  Future<Device?> getActive() async {
    return (_db.select(_db.devices)..where((t) => t.isActive.equals(true)))
        .getSingleOrNull();
  }

  Stream<Device?> watchActive() {
    return (_db.select(_db.devices)..where((t) => t.isActive.equals(true)))
        .watchSingleOrNull();
  }

  Future<void> updateLastSeen(int deviceId, int tsEpochMs) async {
    await (_db.update(_db.devices)..where((t) => t.id.equals(deviceId))).write(
      DevicesCompanion(lastSeenAt: Value(tsEpochMs)),
    );
  }

  Future<void> setToken(int deviceId, String token) async {
    await (_db.update(_db.devices)..where((t) => t.id.equals(deviceId))).write(
      DevicesCompanion(token: Value(token)),
    );
  }
}

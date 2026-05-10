import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../data/providers.dart';
import '../settings/providers.dart';
import 'auth_middleware.dart';
import 'foreground_service_controller.dart';
import 'ingest_router.dart';
import 'mdns_broadcaster.dart';

sealed class ServerStatus {
  const ServerStatus();
}

final class ServerStopped extends ServerStatus {
  const ServerStopped();
}

final class ServerRunning extends ServerStatus {
  const ServerRunning({required this.port});
  final int port;
}

final class ServerError extends ServerStatus {
  const ServerError({required this.message});
  final String message;
}

/// Owns the embedded HTTP server's lifecycle, the parallel mDNS broadcast,
/// and the Android foreground service that keeps the process alive when the
/// screen is off.
/// Idempotent: calling [start] when already running is a no-op.
class ServerController extends Notifier<ServerStatus> {
  HttpServer? _httpServer;
  final MdnsBroadcaster _mdns = MdnsBroadcaster();
  final ForegroundServiceController _fg = ForegroundServiceController();

  @override
  ServerStatus build() {
    ref.onDispose(_cleanup);
    return const ServerStopped();
  }

  Future<void> _cleanup() async {
    await _mdns.stop();
    await _fg.stop();
    await _httpServer?.close(force: true);
    _httpServer = null;
  }

  Future<void> start() async {
    if (_httpServer != null) return;

    final port = ref.read(settingsRepoProvider).serverPort;
    final deviceRepo = ref.read(deviceRepoProvider);
    final sensorRepo = ref.read(sensorReadingRepoProvider);
    final eventRepo = ref.read(eventRepoProvider);

    final router = buildIngestRouter(
      deviceRepo: deviceRepo,
      sensorRepo: sensorRepo,
      eventRepo: eventRepo,
    );

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(
          tokenAuthMiddleware(
            expected: () async => (await deviceRepo.getActive())?.token,
          ),
        )
        .addHandler(router);

    try {
      _httpServer = await shelf_io.serve(pipeline, '0.0.0.0', port);
    } catch (e) {
      state = ServerError(message: 'failed to bind :$port — $e');
      return;
    }

    // mDNS is best-effort: failure here doesn't stop the HTTP server.
    try {
      await _mdns.start(port: port);
    } catch (_) {
      // ignore — server still works on manual IP.
    }

    // Foreground service is best-effort too — outside Android (e.g. tests)
    // it's a no-op, and a failure to bind the FG notification shouldn't
    // tear down a working server.
    try {
      final ip = await _lanIp();
      await _fg.start(
        title: 'VerdaPot — sunucu çalışıyor',
        body: ip == null ? 'Port $port dinleniyor' : 'http://$ip:$port',
      );
    } catch (_) {
      // ignore.
    }

    state = ServerRunning(port: port);
  }

  Future<void> stop() async {
    await _mdns.stop();
    await _fg.stop();
    await _httpServer?.close(force: true);
    _httpServer = null;
    state = const ServerStopped();
  }

  Future<void> restart() async {
    await stop();
    await start();
  }

  Future<String?> _lanIp() async {
    try {
      return await NetworkInfo().getWifiIP();
    } catch (_) {
      return null;
    }
  }
}

final serverControllerProvider =
    NotifierProvider<ServerController, ServerStatus>(ServerController.new);

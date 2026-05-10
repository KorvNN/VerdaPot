import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'server_controller.dart';

enum HealthState { unknown, ok, failing, restarting }

/// Probes the local embedded HTTP server's `/health` endpoint on a fixed
/// cadence. Two consecutive failures trigger a [ServerController.restart]
/// so a wedged server (rare, but the foreground service is fallible) recovers
/// without the user having to do anything.
///
/// The poller is platform-free and accepts an injected probe so unit tests can
/// drive arbitrary success/failure sequences without standing up an HTTP server.
class HealthPoller extends Notifier<HealthState> {
  /// How often to probe `/health`. The roadmap calls for 30 s while
  /// foregrounded; tests override this.
  static const Duration defaultInterval = Duration(seconds: 30);

  /// Failures in a row before we ask the [ServerController] to restart.
  static const int failureThreshold = 2;

  Timer? _timer;
  int _consecutiveFailures = 0;

  Future<bool> Function(int port)? _probeOverride;
  Duration _interval = defaultInterval;

  @override
  HealthState build() {
    ref.onDispose(_cancel);
    return HealthState.unknown;
  }

  /// Override the probe (for tests) and/or the polling interval. Must be
  /// called before [run] takes effect.
  void configure({
    Future<bool> Function(int port)? probe,
    Duration? interval,
  }) {
    _probeOverride = probe;
    if (interval != null) _interval = interval;
  }

  /// Begin (or restart) the polling loop. Safe to call repeatedly.
  void run() {
    _cancel();
    _timer = Timer.periodic(_interval, (_) => _tick());
  }

  Future<void> tickForTest() => _tick();

  void _cancel() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    final status = ref.read(serverControllerProvider);
    if (status is! ServerRunning) {
      // Server is intentionally stopped or already errored — let the
      // controller's own state machine drive recovery.
      _consecutiveFailures = 0;
      state = HealthState.unknown;
      return;
    }

    final ok = await _probe(status.port);
    if (ok) {
      _consecutiveFailures = 0;
      state = HealthState.ok;
      return;
    }

    _consecutiveFailures++;
    if (_consecutiveFailures < failureThreshold) {
      state = HealthState.failing;
      return;
    }

    state = HealthState.restarting;
    _consecutiveFailures = 0;
    // Best-effort: the controller already swallows internal failures.
    await ref.read(serverControllerProvider.notifier).restart();
  }

  Future<bool> _probe(int port) {
    final override = _probeOverride;
    if (override != null) return override(port);
    return _defaultProbe(port);
  }

  Future<bool> _defaultProbe(int port) async {
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 2);
      try {
        final req =
            await client.getUrl(Uri.parse('http://127.0.0.1:$port/health'));
        final res = await req.close().timeout(const Duration(seconds: 2));
        await res.drain<void>();
        return res.statusCode == 200;
      } finally {
        client.close(force: true);
      }
    } catch (_) {
      return false;
    }
  }
}

final healthPollerProvider =
    NotifierProvider<HealthPoller, HealthState>(HealthPoller.new);

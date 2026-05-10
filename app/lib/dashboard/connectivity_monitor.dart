import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';

/// Cihazın en son veri gönderdiği zamana bakarak çevrimiçi/çevrimdışı durumunu
/// üretir. Cihaz 30 saniyede bir /ingest gönderdiği için ardı ardına 3 döngünün
/// atlanması (90 sn) çevrimdışı kabul edilir. Durum geçişleri history'de
/// görünsün diye `events` tablosuna DEVICE_ONLINE / DEVICE_OFFLINE olarak da
/// kaydedilir.
const _offlineThreshold = Duration(seconds: 5);
const _checkInterval    = Duration(seconds: 2);

class ConnectivityState {
  const ConnectivityState({required this.online, this.lastSeenAt});
  final bool      online;
  final DateTime? lastSeenAt;

  ConnectivityState.unknown()
      : online = false,
        lastSeenAt = null;
}

class ConnectivityNotifier extends Notifier<ConnectivityState> {
  Timer? _timer;
  // Default true seçilir ki cihaz hiç bağlanmamışken bile ilk offline tespiti
  // bir geçiş eventi üretsin.
  bool _lastReportedOnline = true;

  @override
  ConnectivityState build() {
    _timer?.cancel();
    _timer = Timer.periodic(_checkInterval, (_) => _check());
    ref.onDispose(() => _timer?.cancel());
    Future.microtask(_check);
    return ConnectivityState.unknown();
  }

  Future<void> _check() async {
    final deviceRepo = ref.read(deviceRepoProvider);
    final device = await deviceRepo.getActive();
    if (device == null) return;

    final lastSeen = device.lastSeenAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(device.lastSeenAt!);

    final now = DateTime.now();
    final online = lastSeen != null &&
        now.difference(lastSeen) < _offlineThreshold;

    state = ConnectivityState(online: online, lastSeenAt: lastSeen);

    // Yalnızca durum değiştiğinde event yaz — sürekli aynı duruma yazma
    if (online != _lastReportedOnline) {
      final eventRepo = ref.read(eventRepoProvider);
      await eventRepo.insert(EventsCompanion(
        deviceId: Value(device.id),
        ts:       Value(now.millisecondsSinceEpoch),
        kind:     Value(online ? 'DEVICE_ONLINE' : 'DEVICE_OFFLINE'),
      ));
      _lastReportedOnline = online;
    }
  }
}

final connectivityProvider =
    NotifierProvider<ConnectivityNotifier, ConnectivityState>(
        ConnectivityNotifier.new);

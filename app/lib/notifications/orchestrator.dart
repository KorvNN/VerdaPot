import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../dashboard/providers.dart';
import 'notifications_service.dart' show kAlarmsChannelId;
import 'providers.dart';

/// Cihaz tarafından üretilen eventleri dinler ve kullanıcıya yansıması
/// gerekenleri Android bildirimi olarak yüzeye çıkarır. Tekrar eden olaylar
/// için her event türünün ayrı 30 dakikalık cooldown'u vardır; aynı durum
/// ardı ardına 30 kez gelse bile sadece bir bildirim üretilir.
///
/// Bildirim üretilen eventler:
///   • ALARM_START        — "⚠️ {tip} alarmı"
///   • NO_PLANT_SELECTED  — "Bitki seçilmedi"
///   • DEVICE_OFFLINE     — "Cihaz çevrimdışı" (yüksek öncelik)
///   • DEVICE_ONLINE      — bilgilendirme
class NotificationOrchestrator extends Notifier<void> {
  final _deduper = _EventDeduper(cooldown: const Duration(minutes: 30));
  int? _lastSeenEventId;

  @override
  void build() {
    ref.listen<AsyncValue<Device?>>(activeDeviceProvider, (_, next) {
      final device = next.asData?.value;
      if (device == null) return;
      _watchEvents(device.id);
    }, fireImmediately: true);
  }

  void _watchEvents(int deviceId) {
    final repo = ref.read(eventRepoProvider);
    repo.watchRecent(deviceId, limit: 10).listen((events) {
      if (events.isEmpty) return;
      final newest = events.first;

      // İlk akışta sadece "şimdiye kadar olanlar" işaretlenir; uygulama açılır
      // açılmaz eski bildirimlerin yağmaya başlaması istenmez.
      if (_lastSeenEventId == null) {
        _lastSeenEventId = newest.id;
        return;
      }

      // Son işlenen ID'den yeni olan her şeyi sırayla değerlendir
      for (final e in events) {
        if (e.id <= _lastSeenEventId!) break;
        _maybeFire(e);
      }
      _lastSeenEventId = newest.id;
    });
  }

  Future<void> _maybeFire(Event e) async {
    final now = DateTime.now();
    if (!_deduper.shouldNotify(e.kind, now)) return;

    final svc = ref.read(notificationsServiceProvider);
    final spec = _specFor(e);
    if (spec == null) return;

    await svc.show(
      id: e.id,
      title: spec.title,
      body: spec.body,
      channelId: kAlarmsChannelId,
      importance: spec.high ? Importance.high : Importance.defaultImportance,
    );
  }

  _NotifSpec? _specFor(Event e) {
    switch (e.kind) {
      case 'ALARM_START':
        final p = _payload(e);
        final type = p['type']?.toString() ?? 'BİLİNMİYOR';
        final value = p['value']?.toString() ?? '';
        return _NotifSpec(
          title: '⚠️ Alarm: ${_alarmLabel(type)}',
          body: value.isEmpty ? '' : 'Mevcut değer: $value',
          high: type == 'TEMP_LOW' || type == 'TEMP_HIGH',
        );
      case 'NO_PLANT_SELECTED':
        return const _NotifSpec(
          title: 'Bitki seçilmedi',
          body: 'Otomatik sulama için bir bitki seç',
          high: false,
        );
      case 'DEVICE_OFFLINE':
        return const _NotifSpec(
          title: 'Cihaz çevrimdışı',
          body: 'ESP32\'den son 90 saniyedir veri gelmedi',
          high: true,
        );
      case 'DEVICE_ONLINE':
        return const _NotifSpec(
          title: 'Cihaz bağlandı',
          body: 'Smart Pot şimdi çevrimiçi',
          high: false,
        );
      default:
        return null;
    }
  }

  Map<String, dynamic> _payload(Event e) {
    if (e.payload == null) return {};
    try {
      final v = jsonDecode(e.payload!);
      return v is Map<String, dynamic> ? v : <String, dynamic>{};
    } catch (_) {
      return {};
    }
  }

  String _alarmLabel(String type) {
    switch (type) {
      case 'TEMP_LOW':   return 'Sıcaklık düşük';
      case 'TEMP_HIGH':  return 'Sıcaklık yüksek';
      case 'RH_LOW':     return 'Nem düşük';
      case 'RH_HIGH':    return 'Nem yüksek';
      case 'LIGHT_LOW':  return 'Işık az';
      case 'LIGHT_HIGH': return 'Işık fazla';
      default:           return type;
    }
  }
}

class _NotifSpec {
  const _NotifSpec({required this.title, required this.body, required this.high});
  final String title;
  final String body;
  final bool   high;
}

/// Aynı türde art arda gelen eventleri belirli bir süre boyunca yutarak
/// bildirim spam'ini önler.
class _EventDeduper {
  _EventDeduper({required this.cooldown});
  final Duration cooldown;
  final Map<String, DateTime> _lastFired = {};

  bool shouldNotify(String kind, DateTime now) {
    final prev = _lastFired[kind];
    if (prev != null && now.difference(prev) < cooldown) return false;
    _lastFired[kind] = now;
    return true;
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

const String kAlarmsChannelId = 'alarms';
const String kAlarmsChannelName = 'Alarms';
const String kWateringChannelId = 'watering';
const String kWateringChannelName = 'Watering';

/// Thin facade over `flutter_local_notifications`. Two channels:
///   alarms   — high importance (dry soil, tank empty, temp out-of-range)
///   watering — default importance (silent log of WATERING_* events)
class NotificationsService {
  NotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings: settings);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      kAlarmsChannelId,
      kAlarmsChannelName,
      description: 'Plant condition alerts',
      importance: Importance.high,
    ));
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      kWateringChannelId,
      kWateringChannelName,
      description: 'Watering events',
      importance: Importance.defaultImportance,
    ));
    _initialized = true;
  }

  /// Asks for POST_NOTIFICATIONS on Android 13+. No-op (returns true) on
  /// older Android — the permission is granted by default.
  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required Importance importance,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId == kAlarmsChannelId
            ? kAlarmsChannelName
            : kWateringChannelName,
        importance: importance,
        priority: importance == Importance.high
            ? Priority.high
            : Priority.defaultPriority,
      ),
    );
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}

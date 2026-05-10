import 'dart:io' show Platform;

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Thin wrapper over [FlutterForegroundTask] for the embedded shelf server.
/// We don't run a TaskHandler — the foreground service is purely there to
/// keep the Android process alive while the screen is off, with a notification
/// that surfaces the current LAN URL so the user knows where the server lives.
///
/// On non-Android platforms (the test runner, for instance), every method is a
/// no-op so unit tests don't need to mock the platform channels.
class ForegroundServiceController {
  ForegroundServiceController({bool? isAndroid})
      : _isAndroid = isAndroid ?? Platform.isAndroid;

  final bool _isAndroid;
  bool _initialized = false;

  static const _channelId = 'verdapot_server';
  static const _channelName = 'VerdaPot sunucu';

  void _ensureInit() {
    if (!_isAndroid || _initialized) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _channelId,
        channelName: _channelName,
        channelDescription:
            'Persistent notification while the embedded HTTP server runs.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
      ),
    );
    _initialized = true;
  }

  /// Start the foreground service. Idempotent — if already running, updates
  /// the notification text instead.
  Future<void> start({required String title, required String body}) async {
    if (!_isAndroid) return;
    _ensureInit();
    if (await FlutterForegroundTask.isRunningService) {
      await update(title: title, body: body);
      return;
    }
    await FlutterForegroundTask.startService(
      serviceTypes: const [ForegroundServiceTypes.dataSync],
      notificationTitle: title,
      notificationText: body,
    );
  }

  Future<void> update({required String title, required String body}) async {
    if (!_isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: body,
    );
  }

  Future<void> stop() async {
    if (!_isAndroid) return;
    if (!await FlutterForegroundTask.isRunningService) return;
    await FlutterForegroundTask.stopService();
  }
}

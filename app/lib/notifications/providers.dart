import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'notifications_service.dart';
import 'orchestrator.dart';

final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  throw UnimplementedError(
      'notificationsServiceProvider must be overridden in main()');
});

/// Re-export of the plugin handle so tests can stub it.
final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final notificationOrchestratorProvider =
    NotifierProvider<NotificationOrchestrator, void>(
        NotificationOrchestrator.new);

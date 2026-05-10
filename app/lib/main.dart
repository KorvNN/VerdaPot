import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard/connectivity_monitor.dart';
import 'dashboard/dashboard_screen.dart';
import 'data/database.dart';
import 'data/providers.dart';
import 'data/repositories/device_repo.dart';
import 'data/seed/seeder.dart';
import 'l10n/gen/app_localizations.dart';
import 'notifications/notifications_service.dart';
import 'theme/app_theme.dart';
import 'notifications/providers.dart' as notifications;
import 'server/health_poller.dart';
import 'server/server_controller.dart';
import 'settings/providers.dart';
import 'settings/settings_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await Seeder(db).run();
  await DeviceRepo(db).ensureDefault();

  final prefs    = await SharedPreferences.getInstance();
  final settings = SettingsRepo(prefs);

  final notificationsService =
      NotificationsService(FlutterLocalNotificationsPlugin());
  await notificationsService.init();
  // Android 13+ için runtime permission iste; sürüm eski ise sessizce başarılı
  // sayılır. Açılışı bloklamamak için fire-and-forget.
  unawaited(notificationsService.requestPermission());

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        settingsRepoProvider.overrideWithValue(settings),
        notifications.notificationsServiceProvider
            .overrideWithValue(notificationsService),
      ],
      child: const _Bootstrap(),
    ),
  );
}

class _Bootstrap extends ConsumerStatefulWidget {
  const _Bootstrap();
  @override
  ConsumerState<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends ConsumerState<_Bootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cihazdan gelen veriyi karşılayacak gömülü HTTP server'ı başlat
      ref.read(serverControllerProvider.notifier).start();

      // Bildirim orkestratörünü erkenden uyandır ki event akışını dinlemeye
      // başlasın — başlamadan gelen ilk eventler kaçırılırdı.
      ref.read(notifications.notificationOrchestratorProvider.notifier);

      // Periyodik bağlantı kontrolü (cihazın offline olup olmadığını saptar)
      ref.read(connectivityProvider);

      // Server self-watchdog: /health her 30sn'de bir, ardı ardına 2 hata
      // alınırsa server otomatik restart edilir
      ref.read(healthPollerProvider.notifier).run();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: VerdapotTheme.appName,
      theme: VerdapotTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('tr'),
      home: const DashboardScreen(),
    );
  }
}

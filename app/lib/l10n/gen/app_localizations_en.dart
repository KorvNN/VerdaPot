// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Plant';

  @override
  String get tooltipManualWatering => 'Manual watering';

  @override
  String get tooltipHistory => 'History';

  @override
  String get tooltipSettings => 'Settings';

  @override
  String get dashboardEmptyTitle => 'Waiting for your Smart Pot…';

  @override
  String get dashboardEmptyHint =>
      'No readings yet. Open Settings → Pairing to configure the device.';

  @override
  String get dashboardLoading => 'Loading…';

  @override
  String dashboardErrorFmt(Object error) {
    return 'Error: $error';
  }

  @override
  String get dashboardStaleBanner =>
      'No data for over 90s — check the ESP32 connection.';

  @override
  String get dashboardStatusOk => 'Status: OK';

  @override
  String dashboardStatusAlarmFmt(Object durum) {
    return 'Alarm: $durum';
  }

  @override
  String dashboardProfileFmt(Object name) {
    return 'Profile: $name';
  }

  @override
  String get dashboardProfileNone => 'No active profile';

  @override
  String dashboardLastReadingFmt(Object when) {
    return 'Last reading: $when';
  }

  @override
  String dashboardActiveAlarmsFmt(int count) {
    return 'Active alarms ($count)';
  }

  @override
  String get tileTemperature => 'Temperature';

  @override
  String get tileHumidity => 'Humidity';

  @override
  String get tileSoilMoisture => 'Soil Moisture';

  @override
  String get tileLight => 'Light';

  @override
  String get tileWaterTank => 'Water Tank';

  @override
  String get tilePump => 'Pump';

  @override
  String get pumpActive => 'Active';

  @override
  String get pumpIdle => 'Idle';

  @override
  String get waterEmpty => 'EMPTY';

  @override
  String get waterOk => 'OK';

  @override
  String get serverBannerStopped =>
      'Embedded server is stopped — open Settings → Pairing.';

  @override
  String serverBannerErrorFmt(Object message) {
    return 'Embedded server error: $message';
  }

  @override
  String get serverBannerFailing => 'Server health check failed — retrying…';

  @override
  String get serverBannerRestarting => 'Server stalled — restarting…';

  @override
  String get lastSeenJustNow => 'just now';

  @override
  String lastSeenSecondsFmt(int n) {
    return '${n}s ago';
  }

  @override
  String lastSeenMinutesFmt(int n) {
    return '${n}m ago';
  }

  @override
  String lastSeenHoursFmt(int n) {
    return '${n}h ago';
  }

  @override
  String lastSeenDaysFmt(int n) {
    return '${n}d ago';
  }

  @override
  String get alarmLowTemperature => 'Low Temperature';

  @override
  String get alarmHighTemperature => 'High Temperature';

  @override
  String get alarmLowHumidity => 'Low Humidity';

  @override
  String get alarmHighHumidity => 'High Humidity';

  @override
  String get alarmInsufficientLight => 'Insufficient Light';

  @override
  String get alarmDrySoil => 'Dry Soil';

  @override
  String get alarmTankEmpty => 'Water Tank Empty';

  @override
  String get manualWateringTitle => 'Manual watering';

  @override
  String get manualWateringDuration => 'Duration';

  @override
  String get manualWateringStart => 'Start watering';

  @override
  String get manualWateringSending => 'Sending…';

  @override
  String get manualWateringStop => 'Stop pump';

  @override
  String get manualWateringNotPaired =>
      'ESP32 base URL not configured — open Settings → Pairing to set it.';

  @override
  String get manualWateringTankEmpty =>
      'Water tank is EMPTY — refill before watering.';

  @override
  String get manualWateringPumpRunning => 'Pump is currently active.';

  @override
  String get manualWateringFooter =>
      'The pump runs for the selected duration on the ESP32. For repeated runs the firmware also enforces a cool-down.';

  @override
  String manualWateringStartedFmt(int seconds) {
    return 'Watering started (${seconds}s)';
  }

  @override
  String get manualWateringStopSent => 'Stop sent';

  @override
  String manualWateringFailedFmt(Object message) {
    return 'Failed: $message';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'Plant profile';

  @override
  String get settingsProfileSubtitle => 'Active profile, presets, custom';

  @override
  String get settingsCatalog => 'Plant catalog';

  @override
  String get settingsCatalogSubtitle => 'Browse by light & water needs';

  @override
  String get settingsExport => 'Export history (CSV)';

  @override
  String get settingsExportSubtitle => 'All readings for the active device';

  @override
  String get settingsPairing => 'Pairing';

  @override
  String get settingsPairingSubtitle => 'Server, token, mDNS';

  @override
  String get settingsExportNoDevice => 'No active device — pair first';

  @override
  String get settingsExportNoData => 'No readings to export yet';

  @override
  String settingsExportDoneFmt(int n, Object path) {
    return 'Exported $n rows → $path';
  }

  @override
  String get pairingTitle => 'Smart Plant — Pairing';

  @override
  String get pairingServer => 'Server';

  @override
  String pairingRunningFmt(int port) {
    return 'Running on port $port';
  }

  @override
  String pairingStoppedFmt(int port) {
    return 'Stopped (port $port)';
  }

  @override
  String pairingErrorFmt(Object message) {
    return 'Error — $message';
  }

  @override
  String pairingLanFmt(Object ip, int port) {
    return 'LAN address: http://$ip:$port';
  }

  @override
  String get pairingStart => 'Start';

  @override
  String get pairingStop => 'Stop';

  @override
  String get pairingTokenTitle => 'Pairing token';

  @override
  String get pairingTokenHint =>
      'Configure this on the ESP32 as the X-Device-Token header.';

  @override
  String get pairingTokenNone => 'Token not generated yet — open Settings.';

  @override
  String get pairingTokenReveal => 'Reveal';

  @override
  String get pairingTokenHide => 'Hide';

  @override
  String get pairingTokenCopy => 'Copy';

  @override
  String get pairingTokenCopied => 'Token copied to clipboard';

  @override
  String get pairingTokenRegenerate => 'Regenerate';

  @override
  String get pairingTokenRegenerated =>
      'Token regenerated — re-pair the device';

  @override
  String get pairingMdns => 'mDNS';

  @override
  String get pairingMdnsService => 'Service: SmartPlant._smartplant._tcp';

  @override
  String get pairingMdnsHostname => 'Hostname: smartplant.local';

  @override
  String get pairingMdnsHint =>
      'Broadcast starts automatically when the server starts. Falls back silently on networks that block multicast — use the LAN address above as a manual fallback.';

  @override
  String get pairingEsp32Title => 'ESP32 base URL';

  @override
  String get pairingEsp32Hint =>
      'Used for outbound commands (manual watering, profile push). Try http://smartpot.local or the ESP32 LAN IP.';

  @override
  String get pairingEsp32Save => 'Save';

  @override
  String get pairingEsp32Saved => 'ESP32 URL saved';

  @override
  String get profilePickerTitle => 'Plant Profile';

  @override
  String get profilePickerCustom => 'Custom';

  @override
  String get profilePickerCustomChip => 'custom';

  @override
  String get profilePickerEmpty => 'No profiles available.';

  @override
  String profilePickerSyncedFmt(Object name) {
    return 'Synced \"$name\" to ESP32';
  }

  @override
  String profilePickerLocalOnlyFmt(Object name) {
    return 'Activated locally. Pair the ESP32 to sync \"$name\".';
  }

  @override
  String profilePickerSyncFailedFmt(Object message) {
    return 'ESP32 sync failed — reverted: $message';
  }
}

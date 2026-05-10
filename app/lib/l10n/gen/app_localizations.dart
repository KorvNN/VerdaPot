import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Plant'**
  String get appTitle;

  /// No description provided for @tooltipManualWatering.
  ///
  /// In en, this message translates to:
  /// **'Manual watering'**
  String get tooltipManualWatering;

  /// No description provided for @tooltipHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tooltipHistory;

  /// No description provided for @tooltipSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tooltipSettings;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your Smart Pot…'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No readings yet. Open Settings → Pairing to configure the device.'**
  String get dashboardEmptyHint;

  /// No description provided for @dashboardLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get dashboardLoading;

  /// No description provided for @dashboardErrorFmt.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String dashboardErrorFmt(Object error);

  /// No description provided for @dashboardStaleBanner.
  ///
  /// In en, this message translates to:
  /// **'No data for over 90s — check the ESP32 connection.'**
  String get dashboardStaleBanner;

  /// No description provided for @dashboardStatusOk.
  ///
  /// In en, this message translates to:
  /// **'Status: OK'**
  String get dashboardStatusOk;

  /// No description provided for @dashboardStatusAlarmFmt.
  ///
  /// In en, this message translates to:
  /// **'Alarm: {durum}'**
  String dashboardStatusAlarmFmt(Object durum);

  /// No description provided for @dashboardProfileFmt.
  ///
  /// In en, this message translates to:
  /// **'Profile: {name}'**
  String dashboardProfileFmt(Object name);

  /// No description provided for @dashboardProfileNone.
  ///
  /// In en, this message translates to:
  /// **'No active profile'**
  String get dashboardProfileNone;

  /// No description provided for @dashboardLastReadingFmt.
  ///
  /// In en, this message translates to:
  /// **'Last reading: {when}'**
  String dashboardLastReadingFmt(Object when);

  /// No description provided for @dashboardActiveAlarmsFmt.
  ///
  /// In en, this message translates to:
  /// **'Active alarms ({count})'**
  String dashboardActiveAlarmsFmt(int count);

  /// No description provided for @tileTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get tileTemperature;

  /// No description provided for @tileHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get tileHumidity;

  /// No description provided for @tileSoilMoisture.
  ///
  /// In en, this message translates to:
  /// **'Soil Moisture'**
  String get tileSoilMoisture;

  /// No description provided for @tileLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get tileLight;

  /// No description provided for @tileWaterTank.
  ///
  /// In en, this message translates to:
  /// **'Water Tank'**
  String get tileWaterTank;

  /// No description provided for @tilePump.
  ///
  /// In en, this message translates to:
  /// **'Pump'**
  String get tilePump;

  /// No description provided for @pumpActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get pumpActive;

  /// No description provided for @pumpIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get pumpIdle;

  /// No description provided for @waterEmpty.
  ///
  /// In en, this message translates to:
  /// **'EMPTY'**
  String get waterEmpty;

  /// No description provided for @waterOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get waterOk;

  /// No description provided for @serverBannerStopped.
  ///
  /// In en, this message translates to:
  /// **'Embedded server is stopped — open Settings → Pairing.'**
  String get serverBannerStopped;

  /// No description provided for @serverBannerErrorFmt.
  ///
  /// In en, this message translates to:
  /// **'Embedded server error: {message}'**
  String serverBannerErrorFmt(Object message);

  /// No description provided for @serverBannerFailing.
  ///
  /// In en, this message translates to:
  /// **'Server health check failed — retrying…'**
  String get serverBannerFailing;

  /// No description provided for @serverBannerRestarting.
  ///
  /// In en, this message translates to:
  /// **'Server stalled — restarting…'**
  String get serverBannerRestarting;

  /// No description provided for @lastSeenJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get lastSeenJustNow;

  /// No description provided for @lastSeenSecondsFmt.
  ///
  /// In en, this message translates to:
  /// **'{n}s ago'**
  String lastSeenSecondsFmt(int n);

  /// No description provided for @lastSeenMinutesFmt.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String lastSeenMinutesFmt(int n);

  /// No description provided for @lastSeenHoursFmt.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String lastSeenHoursFmt(int n);

  /// No description provided for @lastSeenDaysFmt.
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String lastSeenDaysFmt(int n);

  /// No description provided for @alarmLowTemperature.
  ///
  /// In en, this message translates to:
  /// **'Low Temperature'**
  String get alarmLowTemperature;

  /// No description provided for @alarmHighTemperature.
  ///
  /// In en, this message translates to:
  /// **'High Temperature'**
  String get alarmHighTemperature;

  /// No description provided for @alarmLowHumidity.
  ///
  /// In en, this message translates to:
  /// **'Low Humidity'**
  String get alarmLowHumidity;

  /// No description provided for @alarmHighHumidity.
  ///
  /// In en, this message translates to:
  /// **'High Humidity'**
  String get alarmHighHumidity;

  /// No description provided for @alarmInsufficientLight.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Light'**
  String get alarmInsufficientLight;

  /// No description provided for @alarmDrySoil.
  ///
  /// In en, this message translates to:
  /// **'Dry Soil'**
  String get alarmDrySoil;

  /// No description provided for @alarmTankEmpty.
  ///
  /// In en, this message translates to:
  /// **'Water Tank Empty'**
  String get alarmTankEmpty;

  /// No description provided for @manualWateringTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual watering'**
  String get manualWateringTitle;

  /// No description provided for @manualWateringDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get manualWateringDuration;

  /// No description provided for @manualWateringStart.
  ///
  /// In en, this message translates to:
  /// **'Start watering'**
  String get manualWateringStart;

  /// No description provided for @manualWateringSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get manualWateringSending;

  /// No description provided for @manualWateringStop.
  ///
  /// In en, this message translates to:
  /// **'Stop pump'**
  String get manualWateringStop;

  /// No description provided for @manualWateringNotPaired.
  ///
  /// In en, this message translates to:
  /// **'ESP32 base URL not configured — open Settings → Pairing to set it.'**
  String get manualWateringNotPaired;

  /// No description provided for @manualWateringTankEmpty.
  ///
  /// In en, this message translates to:
  /// **'Water tank is EMPTY — refill before watering.'**
  String get manualWateringTankEmpty;

  /// No description provided for @manualWateringPumpRunning.
  ///
  /// In en, this message translates to:
  /// **'Pump is currently active.'**
  String get manualWateringPumpRunning;

  /// No description provided for @manualWateringFooter.
  ///
  /// In en, this message translates to:
  /// **'The pump runs for the selected duration on the ESP32. For repeated runs the firmware also enforces a cool-down.'**
  String get manualWateringFooter;

  /// No description provided for @manualWateringStartedFmt.
  ///
  /// In en, this message translates to:
  /// **'Watering started ({seconds}s)'**
  String manualWateringStartedFmt(int seconds);

  /// No description provided for @manualWateringStopSent.
  ///
  /// In en, this message translates to:
  /// **'Stop sent'**
  String get manualWateringStopSent;

  /// No description provided for @manualWateringFailedFmt.
  ///
  /// In en, this message translates to:
  /// **'Failed: {message}'**
  String manualWateringFailedFmt(Object message);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Plant profile'**
  String get settingsProfile;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Active profile, presets, custom'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsCatalog.
  ///
  /// In en, this message translates to:
  /// **'Plant catalog'**
  String get settingsCatalog;

  /// No description provided for @settingsCatalogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse by light & water needs'**
  String get settingsCatalogSubtitle;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export history (CSV)'**
  String get settingsExport;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All readings for the active device'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsPairing.
  ///
  /// In en, this message translates to:
  /// **'Pairing'**
  String get settingsPairing;

  /// No description provided for @settingsPairingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Server, token, mDNS'**
  String get settingsPairingSubtitle;

  /// No description provided for @settingsExportNoDevice.
  ///
  /// In en, this message translates to:
  /// **'No active device — pair first'**
  String get settingsExportNoDevice;

  /// No description provided for @settingsExportNoData.
  ///
  /// In en, this message translates to:
  /// **'No readings to export yet'**
  String get settingsExportNoData;

  /// No description provided for @settingsExportDoneFmt.
  ///
  /// In en, this message translates to:
  /// **'Exported {n} rows → {path}'**
  String settingsExportDoneFmt(int n, Object path);

  /// No description provided for @pairingTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Plant — Pairing'**
  String get pairingTitle;

  /// No description provided for @pairingServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get pairingServer;

  /// No description provided for @pairingRunningFmt.
  ///
  /// In en, this message translates to:
  /// **'Running on port {port}'**
  String pairingRunningFmt(int port);

  /// No description provided for @pairingStoppedFmt.
  ///
  /// In en, this message translates to:
  /// **'Stopped (port {port})'**
  String pairingStoppedFmt(int port);

  /// No description provided for @pairingErrorFmt.
  ///
  /// In en, this message translates to:
  /// **'Error — {message}'**
  String pairingErrorFmt(Object message);

  /// No description provided for @pairingLanFmt.
  ///
  /// In en, this message translates to:
  /// **'LAN address: http://{ip}:{port}'**
  String pairingLanFmt(Object ip, int port);

  /// No description provided for @pairingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get pairingStart;

  /// No description provided for @pairingStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get pairingStop;

  /// No description provided for @pairingTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Pairing token'**
  String get pairingTokenTitle;

  /// No description provided for @pairingTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Configure this on the ESP32 as the X-Device-Token header.'**
  String get pairingTokenHint;

  /// No description provided for @pairingTokenNone.
  ///
  /// In en, this message translates to:
  /// **'Token not generated yet — open Settings.'**
  String get pairingTokenNone;

  /// No description provided for @pairingTokenReveal.
  ///
  /// In en, this message translates to:
  /// **'Reveal'**
  String get pairingTokenReveal;

  /// No description provided for @pairingTokenHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get pairingTokenHide;

  /// No description provided for @pairingTokenCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get pairingTokenCopy;

  /// No description provided for @pairingTokenCopied.
  ///
  /// In en, this message translates to:
  /// **'Token copied to clipboard'**
  String get pairingTokenCopied;

  /// No description provided for @pairingTokenRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get pairingTokenRegenerate;

  /// No description provided for @pairingTokenRegenerated.
  ///
  /// In en, this message translates to:
  /// **'Token regenerated — re-pair the device'**
  String get pairingTokenRegenerated;

  /// No description provided for @pairingMdns.
  ///
  /// In en, this message translates to:
  /// **'mDNS'**
  String get pairingMdns;

  /// No description provided for @pairingMdnsService.
  ///
  /// In en, this message translates to:
  /// **'Service: SmartPlant._smartplant._tcp'**
  String get pairingMdnsService;

  /// No description provided for @pairingMdnsHostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname: smartplant.local'**
  String get pairingMdnsHostname;

  /// No description provided for @pairingMdnsHint.
  ///
  /// In en, this message translates to:
  /// **'Broadcast starts automatically when the server starts. Falls back silently on networks that block multicast — use the LAN address above as a manual fallback.'**
  String get pairingMdnsHint;

  /// No description provided for @pairingEsp32Title.
  ///
  /// In en, this message translates to:
  /// **'ESP32 base URL'**
  String get pairingEsp32Title;

  /// No description provided for @pairingEsp32Hint.
  ///
  /// In en, this message translates to:
  /// **'Used for outbound commands (manual watering, profile push). Try http://smartpot.local or the ESP32 LAN IP.'**
  String get pairingEsp32Hint;

  /// No description provided for @pairingEsp32Save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get pairingEsp32Save;

  /// No description provided for @pairingEsp32Saved.
  ///
  /// In en, this message translates to:
  /// **'ESP32 URL saved'**
  String get pairingEsp32Saved;

  /// No description provided for @profilePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant Profile'**
  String get profilePickerTitle;

  /// No description provided for @profilePickerCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get profilePickerCustom;

  /// No description provided for @profilePickerCustomChip.
  ///
  /// In en, this message translates to:
  /// **'custom'**
  String get profilePickerCustomChip;

  /// No description provided for @profilePickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No profiles available.'**
  String get profilePickerEmpty;

  /// No description provided for @profilePickerSyncedFmt.
  ///
  /// In en, this message translates to:
  /// **'Synced \"{name}\" to ESP32'**
  String profilePickerSyncedFmt(Object name);

  /// No description provided for @profilePickerLocalOnlyFmt.
  ///
  /// In en, this message translates to:
  /// **'Activated locally. Pair the ESP32 to sync \"{name}\".'**
  String profilePickerLocalOnlyFmt(Object name);

  /// No description provided for @profilePickerSyncFailedFmt.
  ///
  /// In en, this message translates to:
  /// **'ESP32 sync failed — reverted: {message}'**
  String profilePickerSyncFailedFmt(Object message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

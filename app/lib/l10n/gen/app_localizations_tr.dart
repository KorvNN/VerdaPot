// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Akıllı Saksı';

  @override
  String get tooltipManualWatering => 'Manuel sulama';

  @override
  String get tooltipHistory => 'Geçmiş';

  @override
  String get tooltipSettings => 'Ayarlar';

  @override
  String get dashboardEmptyTitle => 'Akıllı Saksı bekleniyor…';

  @override
  String get dashboardEmptyHint =>
      'Henüz veri yok. Cihazı yapılandırmak için Ayarlar → Eşleştirme\'yi açın.';

  @override
  String get dashboardLoading => 'Yükleniyor…';

  @override
  String dashboardErrorFmt(Object error) {
    return 'Hata: $error';
  }

  @override
  String get dashboardStaleBanner =>
      '90 saniyedir veri yok — ESP32 bağlantısını kontrol edin.';

  @override
  String get dashboardStatusOk => 'Durum: OK';

  @override
  String dashboardStatusAlarmFmt(Object durum) {
    return 'Alarm: $durum';
  }

  @override
  String dashboardProfileFmt(Object name) {
    return 'Profil: $name';
  }

  @override
  String get dashboardProfileNone => 'Etkin profil yok';

  @override
  String dashboardLastReadingFmt(Object when) {
    return 'Son okuma: $when';
  }

  @override
  String dashboardActiveAlarmsFmt(int count) {
    return 'Etkin alarmlar ($count)';
  }

  @override
  String get tileTemperature => 'Sıcaklık';

  @override
  String get tileHumidity => 'Nem';

  @override
  String get tileSoilMoisture => 'Toprak Nemi';

  @override
  String get tileLight => 'Işık';

  @override
  String get tileWaterTank => 'Su Tankı';

  @override
  String get tilePump => 'Pompa';

  @override
  String get pumpActive => 'Çalışıyor';

  @override
  String get pumpIdle => 'Boşta';

  @override
  String get waterEmpty => 'BOŞ';

  @override
  String get waterOk => 'DOLU';

  @override
  String get serverBannerStopped =>
      'Gömülü sunucu durduruldu — Ayarlar → Eşleştirme\'yi açın.';

  @override
  String serverBannerErrorFmt(Object message) {
    return 'Gömülü sunucu hatası: $message';
  }

  @override
  String get serverBannerFailing =>
      'Sağlık kontrolü başarısız — yeniden deneniyor…';

  @override
  String get serverBannerRestarting => 'Sunucu takıldı — yeniden başlatılıyor…';

  @override
  String get lastSeenJustNow => 'az önce';

  @override
  String lastSeenSecondsFmt(int n) {
    return '${n}sn önce';
  }

  @override
  String lastSeenMinutesFmt(int n) {
    return '${n}dk önce';
  }

  @override
  String lastSeenHoursFmt(int n) {
    return '${n}sa önce';
  }

  @override
  String lastSeenDaysFmt(int n) {
    return '${n}g önce';
  }

  @override
  String get alarmLowTemperature => 'Düşük Sıcaklık';

  @override
  String get alarmHighTemperature => 'Yüksek Sıcaklık';

  @override
  String get alarmLowHumidity => 'Düşük Nem';

  @override
  String get alarmHighHumidity => 'Yüksek Nem';

  @override
  String get alarmInsufficientLight => 'Yetersiz Işık';

  @override
  String get alarmDrySoil => 'Kuru Toprak';

  @override
  String get alarmTankEmpty => 'Su Tankı Boş';

  @override
  String get manualWateringTitle => 'Manuel sulama';

  @override
  String get manualWateringDuration => 'Süre';

  @override
  String get manualWateringStart => 'Sulamayı başlat';

  @override
  String get manualWateringSending => 'Gönderiliyor…';

  @override
  String get manualWateringStop => 'Pompayı durdur';

  @override
  String get manualWateringNotPaired =>
      'ESP32 adresi yapılandırılmadı — Ayarlar → Eşleştirme\'den ayarlayın.';

  @override
  String get manualWateringTankEmpty =>
      'Su tankı BOŞ — sulamadan önce doldurun.';

  @override
  String get manualWateringPumpRunning => 'Pompa şu anda çalışıyor.';

  @override
  String get manualWateringFooter =>
      'Pompa, ESP32 üzerinde seçilen süre boyunca çalışır. Tekrar denemelerde donanım kendi bekleme süresini uygular.';

  @override
  String manualWateringStartedFmt(int seconds) {
    return 'Sulama başlatıldı (${seconds}sn)';
  }

  @override
  String get manualWateringStopSent => 'Durdurma gönderildi';

  @override
  String manualWateringFailedFmt(Object message) {
    return 'Başarısız: $message';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsProfile => 'Bitki profili';

  @override
  String get settingsProfileSubtitle => 'Etkin profil, ön ayarlar, özel';

  @override
  String get settingsCatalog => 'Bitki kataloğu';

  @override
  String get settingsCatalogSubtitle => 'Işık ve su ihtiyacına göre göz atın';

  @override
  String get settingsExport => 'Geçmişi dışa aktar (CSV)';

  @override
  String get settingsExportSubtitle => 'Etkin cihazın tüm okumaları';

  @override
  String get settingsPairing => 'Eşleştirme';

  @override
  String get settingsPairingSubtitle => 'Sunucu, jeton, mDNS';

  @override
  String get settingsExportNoDevice => 'Etkin cihaz yok — önce eşleştirin';

  @override
  String get settingsExportNoData => 'Henüz dışa aktarılacak veri yok';

  @override
  String settingsExportDoneFmt(int n, Object path) {
    return '$n satır dışa aktarıldı → $path';
  }

  @override
  String get pairingTitle => 'Akıllı Saksı — Eşleştirme';

  @override
  String get pairingServer => 'Sunucu';

  @override
  String pairingRunningFmt(int port) {
    return 'Çalışıyor — port $port';
  }

  @override
  String pairingStoppedFmt(int port) {
    return 'Durduruldu (port $port)';
  }

  @override
  String pairingErrorFmt(Object message) {
    return 'Hata — $message';
  }

  @override
  String pairingLanFmt(Object ip, int port) {
    return 'LAN adresi: http://$ip:$port';
  }

  @override
  String get pairingStart => 'Başlat';

  @override
  String get pairingStop => 'Durdur';

  @override
  String get pairingTokenTitle => 'Eşleştirme jetonu';

  @override
  String get pairingTokenHint =>
      'Bu değeri ESP32 üzerinde X-Device-Token başlığı olarak yapılandırın.';

  @override
  String get pairingTokenNone => 'Jeton henüz oluşturulmadı — Ayarlar\'ı açın.';

  @override
  String get pairingTokenReveal => 'Göster';

  @override
  String get pairingTokenHide => 'Gizle';

  @override
  String get pairingTokenCopy => 'Kopyala';

  @override
  String get pairingTokenCopied => 'Jeton panoya kopyalandı';

  @override
  String get pairingTokenRegenerate => 'Yeniden oluştur';

  @override
  String get pairingTokenRegenerated =>
      'Jeton yenilendi — cihazı yeniden eşleştirin';

  @override
  String get pairingMdns => 'mDNS';

  @override
  String get pairingMdnsService => 'Servis: SmartPlant._smartplant._tcp';

  @override
  String get pairingMdnsHostname => 'Ana bilgisayar adı: smartplant.local';

  @override
  String get pairingMdnsHint =>
      'Sunucu başladığında yayın otomatik başlar. Multicast\'i engelleyen ağlarda sessizce devre dışı kalır — yedek olarak yukarıdaki LAN adresini kullanın.';

  @override
  String get pairingEsp32Title => 'ESP32 adresi';

  @override
  String get pairingEsp32Hint =>
      'Giden komutlar (manuel sulama, profil gönderimi) için kullanılır. http://smartpot.local veya ESP32 LAN IP\'sini deneyin.';

  @override
  String get pairingEsp32Save => 'Kaydet';

  @override
  String get pairingEsp32Saved => 'ESP32 adresi kaydedildi';

  @override
  String get profilePickerTitle => 'Bitki Profili';

  @override
  String get profilePickerCustom => 'Özel';

  @override
  String get profilePickerCustomChip => 'özel';

  @override
  String get profilePickerEmpty => 'Profil bulunamadı.';

  @override
  String profilePickerSyncedFmt(Object name) {
    return '\"$name\" ESP32\'ye senkronize edildi';
  }

  @override
  String profilePickerLocalOnlyFmt(Object name) {
    return 'Yerel olarak etkinleştirildi. \"$name\" senkronizasyonu için ESP32\'yi eşleştirin.';
  }

  @override
  String profilePickerSyncFailedFmt(Object message) {
    return 'ESP32 senkronizasyonu başarısız — geri alındı: $message';
  }
}

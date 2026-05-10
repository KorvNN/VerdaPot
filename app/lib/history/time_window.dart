/// Window selector for the history view.
enum TimeWindow { last24h, last7d, last30d }

extension TimeWindowX on TimeWindow {
  String get label => switch (this) {
        TimeWindow.last24h => '24 h',
        TimeWindow.last7d => '7 d',
        TimeWindow.last30d => '30 d',
      };

  Duration get duration => switch (this) {
        TimeWindow.last24h => const Duration(hours: 24),
        TimeWindow.last7d => const Duration(days: 7),
        TimeWindow.last30d => const Duration(days: 30),
      };

  /// Veri kopukluğu eşiği — ardışık iki ölçüm bu süreden uzun aralıkla geldiyse
  /// grafik bağlantı kurmaz, açıkça bir boşluk gösterir.
  Duration get gapThreshold => switch (this) {
        TimeWindow.last24h => const Duration(minutes: 90),
        TimeWindow.last7d => const Duration(hours: 3),
        TimeWindow.last30d => const Duration(hours: 6),
      };
}

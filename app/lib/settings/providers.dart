import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_repo.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) {
  throw UnimplementedError('settingsRepoProvider must be overridden in main()');
});

/// Reactive view of [SettingsRepo.esp32BaseUrl]. SharedPreferences itself
/// doesn't notify, so writers must funnel through
/// `esp32BaseUrlProvider.notifier.set(...)` for downstream providers
/// (e.g. esp32ClientProvider) to rebuild.
class Esp32BaseUrlNotifier extends Notifier<String?> {
  @override
  String? build() {
    final raw = ref.watch(settingsRepoProvider).esp32BaseUrl;
    return (raw == null || raw.trim().isEmpty) ? null : raw.trim();
  }

  Future<void> set(String url) async {
    final trimmed = url.trim();
    await ref.read(settingsRepoProvider).setEsp32BaseUrl(trimmed);
    state = trimmed.isEmpty ? null : trimmed;
  }
}

final esp32BaseUrlProvider =
    NotifierProvider<Esp32BaseUrlNotifier, String?>(Esp32BaseUrlNotifier.new);

Future<void> setEsp32BaseUrl(WidgetRef ref, String url) {
  return ref.read(esp32BaseUrlProvider.notifier).set(url);
}

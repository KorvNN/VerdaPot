import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';

/// Aktif bitki — DB'den izlenir, ESP32'ye en son gönderilen profil.
final activeProfileProvider = StreamProvider<PlantProfile?>((ref) {
  return ref.watch(profileRepoProvider).watchActive();
});

/// Tüm bitkiler (preset + custom).
final allProfilesProvider = StreamProvider<List<PlantProfile>>((ref) {
  return ref.watch(profileRepoProvider).watchAll();
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commands/esp32_client.dart';
import '../commands/providers.dart';
import '../data/database.dart';
import '../data/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';
import 'plant_editor_screen.dart';
import 'providers.dart';

/// Bitki seçim ekranı. Veritabanındaki preset bitkiler ve kullanıcının kendi
/// eklediği özel bitkiler tek bir liste halinde sunulur. Bir bitkiye dokunmak
/// onu yerelde aktif olarak işaretler ve cihaza profil olarak gönderir.
class PlantPickerScreen extends ConsumerWidget {
  const PlantPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(allProfilesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(title: 'Bitki Seç'),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: VerdapotTheme.sage,
        foregroundColor: VerdapotTheme.charcoal,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PlantEditorScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Özel Bitki', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(
          child: profilesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Hata: $e')),
            data: (profiles) {
              if (profiles.isEmpty) {
                return const Center(child: Text('Bitki bulunamadı'));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 100),
                itemCount: profiles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _PlantTile(profile: profiles[i]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlantTile extends ConsumerWidget {
  const _PlantTile({required this.profile});
  final PlantProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = profile.bitkiAdiTr ?? profile.bitkiAdi;
    final tempRange =
        '${profile.sicaklikMin.toStringAsFixed(0)}–${profile.sicaklikMax.toStringAsFixed(0)}°C';
    final humRange =
        '%${profile.nemMin.toStringAsFixed(0)}–${profile.nemMax.toStringAsFixed(0)}';

    return GlassCard(
      tint: profile.isActive ? VerdapotTheme.mint.withOpacity(0.7) : null,
      borderColor: profile.isActive
          ? VerdapotTheme.sage.withOpacity(0.7)
          : null,
      onTap: profile.isActive ? null : () => _activateAndSync(context, ref),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: profile.isActive
                ? VerdapotTheme.sage.withOpacity(0.45)
                : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            profile.isActive ? Icons.check : Icons.eco_outlined,
            color: VerdapotTheme.charcoal,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Flexible(
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: VerdapotTheme.charcoal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!profile.isPreset) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: VerdapotTheme.blush.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('ÖZEL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                  ),
                ],
              ]),
              const SizedBox(height: 4),
              Text(
                '$tempRange · $humRange · toprak ≥ ${profile.toprakKuruEsik.toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, color: VerdapotTheme.slate),
              ),
            ],
          ),
        ),
        if (!profile.isPreset)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: VerdapotTheme.slate),
            onPressed: () => _confirmDelete(context, ref),
          ),
      ]),
    );
  }

  Future<void> _activateAndSync(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final repo = ref.read(profileRepoProvider);
    final previous = await repo.getActive();
    final displayName = profile.bitkiAdiTr ?? profile.bitkiAdi;

    await repo.activate(profile.id);

    final client = ref.read(esp32ClientProvider);
    if (client == null) {
      messenger.showSnackBar(SnackBar(
        content: Text('$displayName aktif (cihaz bağlı değil)'),
      ));
      if (navigator.canPop()) navigator.pop();
      return;
    }
    try {
      await client.setProfile(profile);
      messenger.showSnackBar(SnackBar(
        content: Text('$displayName cihaza gönderildi'),
      ));
      if (navigator.canPop()) navigator.pop();
    } on Esp32CommandException catch (e) {
      if (previous != null) await repo.activate(previous.id);
      messenger.showSnackBar(
        SnackBar(content: Text('Senkron hatası: ${e.message}')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bitkiyi sil?'),
        content: Text('${profile.bitkiAdi} silinecek.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('İptal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sil')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(profileRepoProvider).deleteById(profile.id);
    }
  }
}

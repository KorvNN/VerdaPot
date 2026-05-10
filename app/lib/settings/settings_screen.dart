import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../history/csv_export.dart';
import '../pairing/pairing_screen.dart';
import '../profile/plant_picker_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(title: 'Ayarlar'),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(child: ListView(
        padding: const EdgeInsets.only(top: 86),
        children: [
          ListTile(
            leading: const Icon(Icons.eco),
            title: const Text('Bitki Seç'),
            subtitle: const Text('Aktif bitki profilini seç veya özel bitki ekle'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlantPickerScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Geçmişi Dışa Aktar'),
            subtitle: const Text('Tüm sensör verilerini CSV olarak kaydet'),
            onTap: () => _exportCsv(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.wifi_tethering),
            title: const Text('Cihaz Eşleştirme'),
            subtitle: const Text('ESP32 IP adresi ve token'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PairingScreen()),
            ),
          ),
        ],
      )),
    ));
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final device = await ref.read(deviceRepoProvider).getActive();
    if (device == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Aktif cihaz yok')));
      return;
    }
    final readings = await ref.read(sensorReadingRepoProvider).queryWindow(
          deviceId: device.id,
          fromTsMs: 0,
          toTsMs: DateTime.now().millisecondsSinceEpoch,
        );
    if (readings.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Veri yok')));
      return;
    }
    final path = await exportReadingsToCsvFile(readings);
    messenger.showSnackBar(SnackBar(
      content: Text('${readings.length} kayıt → $path'),
      duration: const Duration(seconds: 6),
    ));
  }
}

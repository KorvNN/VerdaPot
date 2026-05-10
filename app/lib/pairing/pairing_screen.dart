import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../server/server_controller.dart';
import '../settings/providers.dart' show settingsRepoProvider, setEsp32BaseUrl;
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';

/// Cihaz eşleştirme ekranı. Kullanıcı buradan:
///   • Telefonun yerel IP'sini görür ve ESP32'nin config.h'ına yapıştırır
///   • Token'ı kopyalar veya yeniler
///   • ESP32'nin IP adresini girip kaydeder
class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  late Future<String?> _wifiIp;
  bool _tokenVisible = false;

  @override
  void initState() {
    super.initState();
    _wifiIp = NetworkInfo().getWifiIP();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(serverControllerProvider);
    final port = ref.watch(settingsRepoProvider).serverPort;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(title: 'Cihaz Eşleştirme'),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 32),
            children: [
              _ServerSection(status: status, configuredPort: port, wifiIp: _wifiIp),
              const SizedBox(height: 14),
              _TokenSection(
                visible: _tokenVisible,
                onToggleVisibility: () =>
                    setState(() => _tokenVisible = !_tokenVisible),
              ),
              const SizedBox(height: 14),
              const _Esp32BaseUrlSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SERVER (telefonun gömülü HTTP server'ı + WiFi IP)
// ─────────────────────────────────────────────────────────────────────────────
class _ServerSection extends ConsumerWidget {
  const _ServerSection({
    required this.status,
    required this.configuredPort,
    required this.wifiIp,
  });

  final ServerStatus status;
  final int configuredPort;
  final Future<String?> wifiIp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(serverControllerProvider.notifier);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _StatusDot(status: status),
            const SizedBox(width: 10),
            const Text('TELEFON SERVERI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: VerdapotTheme.slate,
                )),
          ]),
          const SizedBox(height: 12),
          Text(
            _statusText(status, configuredPort),
            style: const TextStyle(fontSize: 14, color: VerdapotTheme.charcoal),
          ),
          const SizedBox(height: 8),
          FutureBuilder<String?>(
            future: wifiIp,
            builder: (_, snap) {
              final ip = snap.data;
              if (ip == null) {
                return const Text(
                  'WiFi bağlı değil',
                  style: TextStyle(color: VerdapotTheme.slate, fontSize: 12),
                );
              }
              return _IpRow(ip: ip, port: configuredPort);
            },
          ),
          const SizedBox(height: 14),
          Row(children: [
            FilledButton.icon(
              onPressed: status is ServerRunning
                  ? null
                  : () async => controller.start(),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Başlat'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: VerdapotTheme.charcoal,
                side: BorderSide(color: VerdapotTheme.slate.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: status is ServerStopped
                  ? null
                  : () async => controller.stop(),
              icon: const Icon(Icons.stop, size: 18),
              label: const Text('Durdur'),
            ),
          ]),
        ],
      ),
    );
  }

  String _statusText(ServerStatus s, int port) {
    return switch (s) {
      ServerRunning(port: final p) => 'Çalışıyor — port $p dinleniyor',
      ServerStopped() => 'Durdu — başlatınca port $port açılır',
      ServerError(message: final m) => 'Hata: $m',
    };
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});
  final ServerStatus status;
  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      ServerRunning() => VerdapotTheme.statusOk,
      ServerStopped() => VerdapotTheme.statusOffline,
      ServerError() => VerdapotTheme.statusAlert,
    };
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 8),
        ],
      ),
    );
  }
}

class _IpRow extends StatelessWidget {
  const _IpRow({required this.ip, required this.port});
  final String ip;
  final int port;
  @override
  Widget build(BuildContext context) {
    final url = 'http://$ip:$port';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: VerdapotTheme.cream.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        const Icon(Icons.lan, size: 16, color: VerdapotTheme.slate),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            url,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: VerdapotTheme.charcoal,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, size: 18, color: VerdapotTheme.slate),
          tooltip: 'Kopyala',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('IP kopyalandı')),
            );
          },
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOKEN
// ─────────────────────────────────────────────────────────────────────────────
class _TokenSection extends ConsumerWidget {
  const _TokenSection({
    required this.visible,
    required this.onToggleVisibility,
  });
  final bool visible;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(deviceRepoProvider);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CİHAZ TOKEN\'I',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: VerdapotTheme.slate,
              )),
          const SizedBox(height: 8),
          const Text(
            'ESP32 ile aynı token\'ı paylaşmalı; config.h\'a bu token\'ı yapıştırın.',
            style: TextStyle(fontSize: 13, color: VerdapotTheme.charcoal, height: 1.4),
          ),
          const SizedBox(height: 12),
          StreamBuilder<Device?>(
            stream: repo.watchActive(),
            builder: (context, snapshot) {
              final token = snapshot.data?.token;
              if (token == null) {
                return const Text('Henüz token üretilmemiş',
                    style: TextStyle(color: VerdapotTheme.slate));
              }
              final shown = visible
                  ? token
                  : '${'•' * (token.length - 4)}${token.substring(token.length - 4)}';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: VerdapotTheme.cream.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      shown,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: VerdapotTheme.charcoal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _PillButton(
                      icon: visible ? Icons.visibility_off : Icons.visibility,
                      label: visible ? 'Gizle' : 'Göster',
                      onPressed: onToggleVisibility,
                    ),
                    _PillButton(
                      icon: Icons.copy,
                      label: 'Kopyala',
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: token));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token kopyalandı')),
                        );
                      },
                    ),
                    _PillButton(
                      icon: Icons.refresh,
                      label: 'Yenile',
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await repo.regenerateToken(snapshot.data!.id);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Yeni token üretildi')),
                        );
                      },
                    ),
                  ]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: VerdapotTheme.sage.withOpacity(0.4),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 16, color: VerdapotTheme.charcoal),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: VerdapotTheme.charcoal,
                )),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ESP32 BASE URL
// ─────────────────────────────────────────────────────────────────────────────
class _Esp32BaseUrlSection extends ConsumerStatefulWidget {
  const _Esp32BaseUrlSection();

  @override
  ConsumerState<_Esp32BaseUrlSection> createState() =>
      _Esp32BaseUrlSectionState();
}

class _Esp32BaseUrlSectionState extends ConsumerState<_Esp32BaseUrlSection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(settingsRepoProvider).esp32BaseUrl ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ESP32 ADRESİ',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: VerdapotTheme.slate,
              )),
          const SizedBox(height: 8),
          const Text(
            'Cihaza komut göndermek için kullanılan adres. ESP32 hotspot\'a bağlanınca '
            'Serial Monitor\'da görünen IP\'yi yapıştır.',
            style: TextStyle(fontSize: 13, color: VerdapotTheme.charcoal, height: 1.4),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.url,
            autocorrect: false,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            decoration: InputDecoration(
              hintText: 'http://192.168.43.155',
              hintStyle: TextStyle(color: VerdapotTheme.slate.withOpacity(0.5)),
              filled: true,
              fillColor: VerdapotTheme.cream.withOpacity(0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await setEsp32BaseUrl(ref, _controller.text);
              messenger.showSnackBar(
                const SnackBar(content: Text('Adres kaydedildi')),
              );
            },
            icon: const Icon(Icons.save, size: 18),
            label: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

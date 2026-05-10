import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../commands/esp32_client.dart';
import '../commands/providers.dart';
import '../data/database.dart';
import '../data/providers.dart';
import '../history/history_screen.dart';
import '../profile/plant_picker_screen.dart';
import '../profile/providers.dart';
import '../settings/settings_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';
import '../widgets/plant_avatar.dart';
import 'connectivity_monitor.dart';
import 'providers.dart';

/// Verdapot ana ekranı. Üstte canlı animasyonlu bitki avatarı, alt yarıda
/// glassmorphic sensör kartları ve son sulama bilgisi yer alır.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reading       = ref.watch(latestReadingProvider).asData?.value;
    final profile       = ref.watch(activeProfileProvider).asData?.value;
    final connectivity  = ref.watch(connectivityProvider);
    final lastWatering  = ref.watch(lastWateringEventProvider).asData?.value;

    final mood = _resolveMood(
      online: connectivity.online,
      profile: profile,
      reading: reading,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(
        title: VerdapotTheme.appName,
        actions: [
          IconButton(
            icon: const Icon(Icons.eco_outlined),
            tooltip: 'Bitki Seç',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PlantPickerScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: 'Geçmiş',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Ayarlar',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: profile == null
          ? null
          : _WateringFab(onPressed: () => _manualPump(context)),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(latestReadingProvider);
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 86, 16, 96),
              children: [
                _Hero(
                  mood: mood,
                  shape: profile == null
                      ? PlantShape.leafy
                      : shapeForName(profile.bitkiAdi),
                  profile: profile,
                  reading: reading,
                  online: connectivity.online,
                ),
                const SizedBox(height: 10),
                _StatusChips(
                  online: connectivity.online,
                  lastSeenAt: connectivity.lastSeenAt,
                  reading: reading,
                ),
                const SizedBox(height: 10),
                if (reading != null) _SensorGrid(reading: reading, profile: profile),
                if (lastWatering != null) ...[
                  const SizedBox(height: 10),
                  _LastWateringCard(event: lastWatering),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  PlantMood _resolveMood({
    required bool online,
    required PlantProfile? profile,
    required SensorReading? reading,
  }) {
    if (!online && reading == null) return PlantMood.offline;
    if (!online) return PlantMood.offline;
    if (profile == null) return PlantMood.noPlant;
    if (reading == null) return PlantMood.thriving;
    if (reading.pumpActive) return PlantMood.watering;

    final soil = reading.soilMoisture;
    if (soil != null && soil < profile.toprakKuruEsik) return PlantMood.thirsty;

    final lux = reading.lightLux;
    if (lux != null && lux < profile.isikMin) return PlantMood.lowLight;
    if (lux != null && lux > profile.isikMax) return PlantMood.brightLight;

    return PlantMood.thriving;
  }

  Future<void> _manualPump(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final client = ref.read(esp32ClientProvider);
    if (client == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Cihaz bağlı değil')));
      return;
    }
    try {
      final res = await client.manualPump();
      if (res.accepted) {
        messenger.showSnackBar(const SnackBar(content: Text('Sulama başlatıldı')));
      } else {
        final msg = res.reason == 'soil_ok'
            ? 'Toprak nemi yeterli, sulama gerekmiyor'
            : res.reason == 'pump_busy'
                ? 'Pompa zaten çalışıyor'
                : 'Reddedildi: ${res.reason}';
        messenger.showSnackBar(SnackBar(content: Text(msg)));
      }
    } on Esp32CommandException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Hata: ${e.message}')));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// En son WATERING_STARTED eventini bulur (fuzzy gerekçesini göstermek için)
// ─────────────────────────────────────────────────────────────────────────────
final lastWateringEventProvider = StreamProvider<Event?>((ref) {
  final device = ref.watch(activeDeviceProvider).asData?.value;
  if (device == null) return Stream.value(null);
  return ref.watch(eventRepoProvider).watchRecent(device.id, limit: 20).map((events) {
    for (final e in events) {
      if (e.kind == 'WATERING_STARTED') return e;
    }
    return null;
  });
});

// ─────────────────────────────────────────────────────────────────────────────
// Hero — büyük plant avatar + isim + status
// ─────────────────────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  const _Hero({
    required this.mood,
    required this.shape,
    required this.profile,
    required this.reading,
    required this.online,
  });
  final PlantMood mood;
  final PlantShape shape;
  final PlantProfile? profile;
  final SensorReading? reading;
  final bool online;

  @override
  Widget build(BuildContext context) {
    final name = profile == null
        ? 'Bitki seçilmedi'
        : (profile!.bitkiAdiTr ?? profile!.bitkiAdi);
    final subtitle = _moodLabel(mood);

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        children: [
          PlantAvatar(mood: mood, shape: shape, size: 180),
          const SizedBox(height: 4),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _moodColor(mood).withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                color: _moodColor(mood).withOpacity(0.95),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _moodLabel(PlantMood m) {
    switch (m) {
      case PlantMood.thriving:    return 'SAĞLIKLI';
      case PlantMood.thirsty:     return 'SUSADI';
      case PlantMood.watering:    return 'SULANIYOR';
      case PlantMood.offline:     return 'ÇEVRİMDIŞI';
      case PlantMood.noPlant:     return 'BİTKİ SEÇ';
      case PlantMood.lowLight:    return 'IŞIK YETERSİZ';
      case PlantMood.brightLight: return 'IŞIK FAZLA';
    }
  }

  Color _moodColor(PlantMood m) {
    switch (m) {
      case PlantMood.thriving:    return VerdapotTheme.statusOk;
      case PlantMood.thirsty:     return VerdapotTheme.statusWarning;
      case PlantMood.watering:    return const Color(0xFF89C5E8);
      case PlantMood.offline:     return VerdapotTheme.statusOffline;
      case PlantMood.noPlant:     return VerdapotTheme.slate;
      case PlantMood.lowLight:    return VerdapotTheme.statusWarning;
      case PlantMood.brightLight: return VerdapotTheme.statusAlert;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Üst durum çipleri (online/offline + son veri zamanı)
// ─────────────────────────────────────────────────────────────────────────────
class _StatusChips extends StatelessWidget {
  const _StatusChips({
    required this.online,
    required this.lastSeenAt,
    required this.reading,
  });
  final bool online;
  final DateTime? lastSeenAt;
  final SensorReading? reading;

  @override
  Widget build(BuildContext context) {
    final lastTxt = reading == null
        ? 'Veri bekleniyor'
        : 'Son veri ${_relative(reading!.ts)}';

    return Row(children: [
      _Chip(
        icon: online ? Icons.wifi : Icons.wifi_off,
        label: online ? 'Çevrimiçi' : 'Çevrimdışı',
        color: online ? VerdapotTheme.statusOk : VerdapotTheme.statusOffline,
      ),
      const SizedBox(width: 10),
      Expanded(child: _Chip(
        icon: Icons.schedule,
        label: lastTxt,
        color: VerdapotTheme.slate,
      )),
    ]);
  }

  String _relative(int tsMs) {
    final diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(tsMs));
    if (diff.inSeconds < 60) return '${diff.inSeconds} sn önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24)   return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      radius: 16,
      child: Row(children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: VerdapotTheme.charcoal,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sensör Kartları — 2x2 grid
// ─────────────────────────────────────────────────────────────────────────────
class _SensorGrid extends StatelessWidget {
  const _SensorGrid({required this.reading, required this.profile});
  final SensorReading reading;
  final PlantProfile? profile;

  @override
  Widget build(BuildContext context) {
    final tiles = <_SensorTileData>[
      _SensorTileData(
        icon: Icons.thermostat_outlined,
        label: 'Sıcaklık',
        value: reading.temperatureC,
        unit: '°C',
        format: (v) => v.toStringAsFixed(1),
        accent: VerdapotTheme.blush,
        outOfRange: profile != null && reading.temperatureC != null &&
            (reading.temperatureC! < profile!.sicaklikMin ||
             reading.temperatureC! > profile!.sicaklikMax),
      ),
      _SensorTileData(
        icon: Icons.water_drop_outlined,
        label: 'Hava Nemi',
        value: reading.humidityPct,
        unit: '%',
        format: (v) => v.toStringAsFixed(0),
        accent: VerdapotTheme.sky,
        outOfRange: profile != null && reading.humidityPct != null &&
            (reading.humidityPct! < profile!.nemMin ||
             reading.humidityPct! > profile!.nemMax),
      ),
      _SensorTileData(
        icon: Icons.grass_outlined,
        label: 'Toprak Nemi',
        value: reading.soilMoisture?.toDouble(),
        unit: '%',
        format: (v) => v.toStringAsFixed(0),
        accent: VerdapotTheme.sage,
        outOfRange: profile != null && reading.soilMoisture != null &&
            reading.soilMoisture! < profile!.toprakKuruEsik,
      ),
      _SensorTileData(
        icon: Icons.wb_sunny_outlined,
        label: 'Işık',
        value: reading.lightLux?.toDouble(),
        unit: 'lx',
        format: (v) => v.toStringAsFixed(0),
        accent: const Color(0xFFFFE0A0),
        outOfRange: profile != null && reading.lightLux != null &&
            (reading.lightLux! < profile!.isikMin ||
             reading.lightLux! > profile!.isikMax),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: tiles.map((t) => _SensorTile(data: t)).toList(),
    );
  }
}

class _SensorTileData {
  _SensorTileData({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.format,
    required this.accent,
    required this.outOfRange,
  });
  final IconData icon;
  final String label;
  final double? value;
  final String unit;
  final String Function(double) format;
  final Color accent;
  final bool outOfRange;
}

class _SensorTile extends StatelessWidget {
  const _SensorTile({required this.data});
  final _SensorTileData data;
  @override
  Widget build(BuildContext context) {
    final hasValue = data.value != null;
    return GlassCard(
      padding: const EdgeInsets.all(12),
      tint: data.outOfRange ? VerdapotTheme.statusAlert.withOpacity(0.25) : null,
      borderColor: data.outOfRange
          ? VerdapotTheme.statusAlert.withOpacity(0.6)
          : null,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: data.accent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(data.icon, size: 20, color: VerdapotTheme.charcoal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: VerdapotTheme.slate,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                if (hasValue)
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: VerdapotTheme.charcoal),
                      children: [
                        TextSpan(
                          text: data.format(data.value!),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400, height: 1.0),
                        ),
                        TextSpan(
                          text: ' ${data.unit}',
                          style: const TextStyle(fontSize: 12, color: VerdapotTheme.slate),
                        ),
                      ],
                    ),
                  )
                else
                  const Text('—', style: TextStyle(fontSize: 22, color: VerdapotTheme.slate)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Son Sulama Kartı
// ─────────────────────────────────────────────────────────────────────────────
class _LastWateringCard extends StatelessWidget {
  const _LastWateringCard({required this.event});
  final Event event;
  @override
  Widget build(BuildContext context) {
    final p = event.payload == null
        ? <String, dynamic>{}
        : jsonDecode(event.payload!) as Map<String, dynamic>;
    final sure  = p['sulama_sure']?.toString() ?? '?';
    final powerNum = p['irrigation_power'];
    final power = powerNum is num
        ? '%${(powerNum * 100).toStringAsFixed(0)}'
        : '—';
    final sebepRaw = p['sebep']?.toString() ?? '';
    final sebep = _humanizeSebep(sebepRaw);
    final src   = _humanizeTetikleyici(p['tetikleyici']?.toString() ?? '');

    return GlassCard(
      tint: VerdapotTheme.sky.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF89C5E8).withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.water_drop, color: Color(0xFF4A8AB0), size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              'SON SULAMA',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: VerdapotTheme.slate,
              ),
            ),
            const Spacer(),
            Text(
              _relative(event.ts),
              style: const TextStyle(fontSize: 11, color: VerdapotTheme.slate),
            ),
          ]),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sure',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300, height: 1.0),
              ),
              const Text(' sn', style: TextStyle(fontSize: 16, color: VerdapotTheme.slate)),
              const SizedBox(width: 18),
              Text(
                'Güç: $power',
                style: const TextStyle(fontSize: 14, color: VerdapotTheme.slate),
              ),
            ],
          ),
          if (sebep.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              sebep,
              style: const TextStyle(fontSize: 13, color: VerdapotTheme.charcoal),
            ),
          ],
          if (src.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              src,
              style: const TextStyle(fontSize: 12, color: VerdapotTheme.slate),
            ),
          ],
        ],
      ),
    );
  }

  String _relative(int tsMs) {
    final diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(tsMs));
    if (diff.inSeconds < 60) return '${diff.inSeconds} sn önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24)   return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }

  // Firmware'in fuzzy sebep kodunu insan dostu açıklamaya çevirir.
  String _humanizeSebep(String raw) {
    switch (raw) {
      case 'toprak_kuru + sicaklik_stres':
        return 'Toprak çok kuru ve hava sıcak';
      case 'toprak_kuru + sicaklik_normal':
        return 'Toprak kuru, sıcaklık uygun';
      case 'toprak_kuru + sicaklik_dusuk':
        return 'Toprak kuru, hava soğuk — ihtiyatlı sulama';
      case 'toprak_nemli + sicaklik_yuksek':
        return 'Toprak hafif kuru, hava sıcak';
      case 'sulama_gerekmez':
        return 'Sulama gerekmiyor';
      default:
        return raw;
    }
  }

  String _humanizeTetikleyici(String raw) {
    switch (raw) {
      case 'AUTO':   return 'Otomatik karar';
      case 'MANUAL': return 'Manuel tetik';
      default:       return raw;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Manuel Sulama FAB
// ─────────────────────────────────────────────────────────────────────────────
class _WateringFab extends StatelessWidget {
  const _WateringFab({required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [VerdapotTheme.sage, Color(0xFF89C5E8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: VerdapotTheme.sage.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.water_drop, color: Colors.white),
              SizedBox(width: 8),
              Text('Sula',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            ]),
          ),
        ),
      ),
    );
  }
}

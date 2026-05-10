import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../profile/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';
import 'providers.dart';
import 'sensor_chart.dart';
import 'time_window.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final window = ref.watch(selectedWindowProvider);
    final readingsAsync = ref.watch(historyReadingsProvider);
    final profile = ref.watch(activeProfileProvider).asData?.value;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(title: 'Geçmiş'),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(8),
                  radius: 20,
                  child: SegmentedButton<TimeWindow>(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return VerdapotTheme.sage.withOpacity(0.7);
                        }
                        return Colors.transparent;
                      }),
                      foregroundColor: WidgetStateProperty.all(VerdapotTheme.charcoal),
                      side: WidgetStateProperty.all(BorderSide.none),
                    ),
                    showSelectedIcon: false,
                    segments: [
                      for (final w in TimeWindow.values)
                        ButtonSegment(value: w, label: Text(w.label)),
                    ],
                    selected: {window},
                    onSelectionChanged: (set) =>
                        ref.read(selectedWindowProvider.notifier).set(set.first),
                  ),
                ),
              ),
              Expanded(
                child: readingsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Hata: $e')),
                  data: (readings) => _ChartList(
                    readings: readings,
                    profile: profile,
                    gapThreshold: window.gapThreshold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartList extends StatelessWidget {
  const _ChartList({
    required this.readings,
    required this.profile,
    required this.gapThreshold,
  });

  final List<SensorReading> readings;
  final PlantProfile? profile;
  final Duration gapThreshold;

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return const Center(
        child: Text(
          'Bu aralıkta henüz veri yok.',
          style: TextStyle(color: VerdapotTheme.slate),
        ),
      );
    }

    final charts = <_ChartSpec>[
      _ChartSpec(
        title: 'Sıcaklık',
        unit: '°C',
        valueOf: (r) => r.temperatureC,
        minThreshold: profile?.sicaklikMin,
        maxThreshold: profile?.sicaklikMax,
        minLabel: profile != null ? 'min ${profile!.sicaklikMin.toStringAsFixed(0)}' : null,
        maxLabel: profile != null ? 'max ${profile!.sicaklikMax.toStringAsFixed(0)}' : null,
      ),
      _ChartSpec(
        title: 'Hava Nemi',
        unit: '%',
        valueOf: (r) => r.humidityPct,
        minThreshold: profile?.nemMin,
        maxThreshold: profile?.nemMax,
        minLabel: profile != null ? 'min ${profile!.nemMin.toStringAsFixed(0)}' : null,
        maxLabel: profile != null ? 'max ${profile!.nemMax.toStringAsFixed(0)}' : null,
      ),
      _ChartSpec(
        title: 'Toprak Nemi',
        unit: '%',
        valueOf: (r) => r.soilMoisture?.toDouble(),
        minThreshold: profile?.toprakKuruEsik,
        minLabel: profile != null
            ? 'eşik ${profile!.toprakKuruEsik.toStringAsFixed(0)}'
            : null,
      ),
      _ChartSpec(
        title: 'Işık',
        unit: 'lux',
        valueOf: (r) => r.lightLux?.toDouble(),
        minThreshold: profile?.isikMin.toDouble(),
        minLabel: profile != null ? 'min ${profile!.isikMin}' : null,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: charts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final c = charts[i];
        return GlassCard(
          padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
          child: SensorChart(
            title: c.title,
            unit: c.unit,
            readings: readings,
            gapThreshold: gapThreshold,
            valueOf: c.valueOf,
            minThreshold: c.minThreshold,
            maxThreshold: c.maxThreshold,
            minThresholdLabel: c.minLabel,
            maxThresholdLabel: c.maxLabel,
          ),
        );
      },
    );
  }
}

class _ChartSpec {
  _ChartSpec({
    required this.title,
    required this.unit,
    required this.valueOf,
    this.minThreshold,
    this.maxThreshold,
    this.minLabel,
    this.maxLabel,
  });
  final String title;
  final String unit;
  final double? Function(SensorReading) valueOf;
  final double? minThreshold;
  final double? maxThreshold;
  final String? minLabel;
  final String? maxLabel;
}

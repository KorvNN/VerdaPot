import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/database.dart';
import 'gap_detection.dart';

/// Generic single-metric line chart used for each sensor in the history view.
/// Renders multiple line segments separated by data outages (no interpolation
/// across gaps), and draws optional horizontal threshold guidelines.
class SensorChart extends StatelessWidget {
  const SensorChart({
    super.key,
    required this.title,
    required this.unit,
    required this.readings,
    required this.gapThreshold,
    required this.valueOf,
    this.minThreshold,
    this.maxThreshold,
    this.minThresholdLabel,
    this.maxThresholdLabel,
  });

  final String title;
  final String unit;
  final List<SensorReading> readings;
  final Duration gapThreshold;
  final double? Function(SensorReading) valueOf;
  final double? minThreshold;
  final double? maxThreshold;
  final String? minThresholdLabel;
  final String? maxThresholdLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final populated =
        readings.where((r) => valueOf(r) != null).toList(growable: false);

    if (populated.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('No data in this window.'),
            ],
          ),
        ),
      );
    }

    final runs = splitReadingsByGap(populated, maxGap: gapThreshold);

    final allValues = populated.map(valueOf).whereType<double>().toList();
    final dataMin = allValues.reduce((a, b) => a < b ? a : b);
    final dataMax = allValues.reduce((a, b) => a > b ? a : b);
    var minY = dataMin;
    if (minThreshold != null && minThreshold! < minY) minY = minThreshold!;
    var maxY = dataMax;
    if (maxThreshold != null && maxThreshold! > maxY) maxY = maxThreshold!;
    final pad = (maxY - minY).abs() * 0.1 + 1;

    final firstTs = populated.first.ts.toDouble();
    final lastTs = populated.last.ts.toDouble();
    final spanMs = lastTs - firstTs;

    final bars = <LineChartBarData>[
      for (final run in runs)
        LineChartBarData(
          spots: [
            for (final r in run)
              FlSpot(r.ts.toDouble(), valueOf(r)!),
          ],
          isCurved: false,
          color: theme.colorScheme.primary,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
    ];

    final extraLines = <HorizontalLine>[
      if (minThreshold != null)
        HorizontalLine(
          y: minThreshold!,
          color: theme.colorScheme.error.withValues(alpha: 0.6),
          strokeWidth: 1,
          dashArray: [4, 4],
          label: HorizontalLineLabel(
            show: minThresholdLabel != null,
            labelResolver: (_) => minThresholdLabel ?? '',
            alignment: Alignment.bottomLeft,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ),
      if (maxThreshold != null)
        HorizontalLine(
          y: maxThreshold!,
          color: theme.colorScheme.error.withValues(alpha: 0.6),
          strokeWidth: 1,
          dashArray: [4, 4],
          label: HorizontalLineLabel(
            show: maxThresholdLabel != null,
            labelResolver: (_) => maxThresholdLabel ?? '',
            alignment: Alignment.topLeft,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.error),
          ),
        ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(unit,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minX: firstTs,
                  maxX: lastTs,
                  minY: minY - pad,
                  maxY: maxY + pad,
                  lineBarsData: bars,
                  extraLinesData: ExtraLinesData(horizontalLines: extraLines),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: ((maxY - minY) / 4).clamp(1, double.infinity),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: theme.colorScheme.outline),
                      left: BorderSide(color: theme.colorScheme.outline),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          v.toStringAsFixed(0),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: spanMs <= 0 ? 1 : spanMs / 4,
                        getTitlesWidget: (v, _) {
                          final dt =
                              DateTime.fromMillisecondsSinceEpoch(v.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(_formatTick(dt, lastTs - firstTs),
                                style: theme.textTheme.labelSmall),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: const LineTouchData(enabled: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTick(DateTime dt, double spanMs) {
    if (spanMs > const Duration(days: 2).inMilliseconds) {
      return '${dt.month}/${dt.day}';
    }
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

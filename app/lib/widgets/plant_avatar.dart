import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Bitkinin biyolojik tipine göre çizim varyasyonu.
enum PlantShape {
  /// Standart yapraklı bitkiler — tek gövde + yumuşak yapraklar.
  leafy,

  /// Sukulent / kaktüs — sapsız, dik kalın gövde, dikenli yüzey.
  succulent,

  /// Çiçekli bitkiler — yapraklı taban + tepede pastel çiçek.
  flowering,
}

/// Bitki adından şekil grubunu belirler. Plant catalog'daki 15 preset için
/// önceden eşleştirilmiş; tanımsız adlar `leafy` döner.
PlantShape shapeForName(String name) {
  const succulents = {'Cactus', 'Sansevieria'};
  const flowering = {
    'Peace Lily', 'Begonia', 'African Violet',
    'Chrysanthemum', 'Camellia', 'Hydrangea', 'Calathea',
  };
  if (succulents.contains(name)) return PlantShape.succulent;
  if (flowering.contains(name)) return PlantShape.flowering;
  return PlantShape.leafy;
}

/// Sensör verisi ve bağlantı durumuna göre değişen ruh hali.
enum PlantMood {
  thriving,
  thirsty,
  watering,
  offline,
  noPlant,
  lowLight,
  brightLight,
}

class PlantAvatar extends StatefulWidget {
  const PlantAvatar({
    super.key,
    required this.mood,
    this.shape = PlantShape.leafy,
    this.size = 220,
  });

  final PlantMood mood;
  final PlantShape shape;
  final double size;

  @override
  State<PlantAvatar> createState() => _PlantAvatarState();
}

class _PlantAvatarState extends State<PlantAvatar>
    with TickerProviderStateMixin {
  late AnimationController _sway;
  late AnimationController _breathe;
  late AnimationController _drops;

  @override
  void initState() {
    super.initState();
    _sway = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _breathe = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _drops = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _applyMoodSpeeds();
  }

  @override
  void didUpdateWidget(covariant PlantAvatar old) {
    super.didUpdateWidget(old);
    if (old.mood != widget.mood) _applyMoodSpeeds();
  }

  void _applyMoodSpeeds() {
    switch (widget.mood) {
      case PlantMood.watering:
        _sway.duration = const Duration(milliseconds: 900);
        break;
      case PlantMood.thirsty:
        _sway.duration = const Duration(seconds: 5);
        break;
      case PlantMood.offline:
      case PlantMood.noPlant:
        _sway.stop();
        return;
      default:
        _sway.duration = const Duration(seconds: 3);
    }
    if (!_sway.isAnimating) _sway.repeat(reverse: true);
  }

  @override
  void dispose() {
    _sway.dispose();
    _breathe.dispose();
    _drops.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_sway, _breathe, _drops]),
        builder: (_, __) {
          return CustomPaint(
            painter: _PlantPainter(
              shape: widget.shape,
              mood: widget.mood,
              sway: _sway.value,
              breathe: _breathe.value,
              drops: _drops.value,
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter — shape'e göre dallanır
// ─────────────────────────────────────────────────────────────────────────────
class _PlantPainter extends CustomPainter {
  _PlantPainter({
    required this.shape,
    required this.mood,
    required this.sway,
    required this.breathe,
    required this.drops,
  });

  final PlantShape shape;
  final PlantMood  mood;
  final double sway;
  final double breathe;
  final double drops;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final palette = _palette();

    final breatheScale = 1.0 + (math.sin(breathe * math.pi * 2) * 0.015);
    canvas.save();
    canvas.translate(cx, h);
    canvas.scale(breatheScale, breatheScale);
    canvas.translate(-cx, -h);

    _drawHalo(canvas, w, h, palette);
    _drawPot(canvas, cx, w, h, palette);

    switch (shape) {
      case PlantShape.leafy:
        _drawStem(canvas, cx, h, palette);
        _drawLeaves(canvas, cx, h, palette);
        _drawTopBud(canvas, cx, h, palette);
        break;
      case PlantShape.succulent:
        _drawSucculent(canvas, cx, h, palette);
        break;
      case PlantShape.flowering:
        _drawStem(canvas, cx, h, palette);
        _drawLeaves(canvas, cx, h, palette, leafCount: 4, lower: true);
        _drawFlower(canvas, cx, h, palette);
        break;
    }

    canvas.restore();

    if (mood == PlantMood.watering)    _drawWaterDrops(canvas, cx, h);
    if (mood == PlantMood.brightLight) _drawSunOverlay(canvas, w, h);
    if (mood == PlantMood.lowLight)    _drawShadowOverlay(canvas, w, h);
  }

  // ── Palet ────────────────────────────────────────────────────────────────
  _Palette _palette() {
    switch (mood) {
      case PlantMood.thriving:
        return _Palette(
          leaf: const Color(0xFF8FCFA1), stem: const Color(0xFF6BA77E),
          pot: VerdapotTheme.terracotta, soil: const Color(0xFF7A5944),
          glow: VerdapotTheme.sage.withOpacity(0.35),
          flower: VerdapotTheme.blush,
        );
      case PlantMood.thirsty:
        return _Palette(
          leaf: const Color(0xFFC9C58A), stem: const Color(0xFF9A9568),
          pot: VerdapotTheme.terracotta, soil: const Color(0xFFA0826A),
          glow: const Color(0xFFE8B86A).withOpacity(0.25),
          flower: const Color(0xFFE8C9A8),
        );
      case PlantMood.watering:
        return _Palette(
          leaf: const Color(0xFF7DC79A), stem: const Color(0xFF5C8E70),
          pot: VerdapotTheme.terracotta, soil: const Color(0xFF5C3F2E),
          glow: const Color(0xFF89C5E8).withOpacity(0.4),
          flower: VerdapotTheme.blush,
        );
      case PlantMood.offline:
        return _Palette(
          leaf: const Color(0xFFB8BFBC), stem: const Color(0xFF8A918E),
          pot: const Color(0xFFB8A89A), soil: const Color(0xFF8A7C70),
          glow: Colors.transparent,
          flower: const Color(0xFFCFCEC8),
        );
      case PlantMood.noPlant:
        return _Palette(
          leaf: const Color(0xFFE0E0DC).withOpacity(0.4),
          stem: const Color(0xFFCFCEC8).withOpacity(0.4),
          pot: VerdapotTheme.terracotta.withOpacity(0.6),
          soil: const Color(0xFF7A5944).withOpacity(0.5),
          glow: Colors.transparent,
          flower: VerdapotTheme.blush.withOpacity(0.4),
        );
      case PlantMood.lowLight:
        return _Palette(
          leaf: const Color(0xFF6B8C77), stem: const Color(0xFF4F6B5B),
          pot: VerdapotTheme.terracotta, soil: const Color(0xFF5C4434),
          glow: Colors.transparent,
          flower: const Color(0xFFB8A0AA),
        );
      case PlantMood.brightLight:
        return _Palette(
          leaf: const Color(0xFFA8DCB6), stem: const Color(0xFF80B58F),
          pot: VerdapotTheme.terracotta, soil: const Color(0xFF8A6450),
          glow: const Color(0xFFFFE8A8).withOpacity(0.5),
          flower: const Color(0xFFFFD0CD),
        );
    }
  }

  // ── Glow halo ────────────────────────────────────────────────────────────
  void _drawHalo(Canvas canvas, double w, double h, _Palette p) {
    if (p.glow == Colors.transparent) return;
    final paint = Paint()
      ..shader = RadialGradient(colors: [p.glow, p.glow.withOpacity(0)])
          .createShader(Rect.fromCircle(center: Offset(w / 2, h * 0.6), radius: w * 0.5));
    canvas.drawCircle(Offset(w / 2, h * 0.6), w * 0.5, paint);
  }

  // ── Saksı ────────────────────────────────────────────────────────────────
  void _drawPot(Canvas canvas, double cx, double w, double h, _Palette p) {
    final potTop = h * 0.70;
    final potBottom = h * 0.95;
    final topW = w * 0.55;
    final botW = w * 0.42;

    final path = Path()
      ..moveTo(cx - topW / 2, potTop)
      ..lineTo(cx + topW / 2, potTop)
      ..lineTo(cx + botW / 2, potBottom)
      ..lineTo(cx - botW / 2, potBottom)
      ..close();
    canvas.drawPath(path, Paint()..color = p.pot);

    canvas.drawLine(
      Offset(cx - topW / 2 - 4, potTop),
      Offset(cx + topW / 2 + 4, potTop),
      Paint()
        ..color = p.pot.withOpacity(0.7)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final soilPath = Path()
      ..moveTo(cx - topW / 2 + 2, potTop - 2)
      ..lineTo(cx + topW / 2 - 2, potTop - 2)
      ..lineTo(cx + topW / 2 - 2, potTop + 6)
      ..lineTo(cx - topW / 2 + 2, potTop + 6)
      ..close();
    canvas.drawPath(soilPath, Paint()..color = p.soil);
  }

  // ── LEAFY: Gövde ─────────────────────────────────────────────────────────
  void _drawStem(Canvas canvas, double cx, double h, _Palette p) {
    final paint = Paint()
      ..color = p.stem
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final swayOffset = math.sin(sway * math.pi * 2) * (mood == PlantMood.thirsty ? 2 : 6);
    final base = Offset(cx, h * 0.70);
    final top = Offset(cx + swayOffset, h * 0.30);
    final ctrl = Offset(cx - swayOffset / 2, h * 0.50);

    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(ctrl.dx, ctrl.dy, top.dx, top.dy);
    canvas.drawPath(path, paint);
  }

  // ── LEAFY: Yapraklar ─────────────────────────────────────────────────────
  void _drawLeaves(
    Canvas canvas,
    double cx,
    double h,
    _Palette p, {
    int leafCount = 6,
    bool lower = false,
  }) {
    final swayAmp = mood == PlantMood.watering ? 0.18 : 0.10;
    final droopAmp = mood == PlantMood.thirsty ? 0.25 : 0.0;
    final sizeMod = mood == PlantMood.lowLight ? 0.75 : 1.0;

    // Çiçekli bitkilerde yapraklar daha aşağıda yoğunlaşır
    final yStart = lower ? 0.65 : 0.62;
    final yEnd = lower ? 0.42 : 0.30;
    final step = (yStart - yEnd) / (leafCount - 1);

    for (int i = 0; i < leafCount; i++) {
      final yRatio = yStart - i * step;
      final leftSide = i % 2 == 0;
      final leafSize = 36 + (i * 2.0).clamp(0, 8);
      final phase = i * 0.15;

      final swayLocal = math.sin((sway + phase) * math.pi * 2) * swayAmp;
      final droop = droopAmp * (1 - yRatio);
      final stemX = cx + (math.sin(sway * math.pi * 2) * 6) * (1 - yRatio);
      final attach = Offset(stemX, h * yRatio);
      final dir = leftSide ? -1 : 1;
      final tip = Offset(
        attach.dx + dir * leafSize * sizeMod,
        attach.dy + swayLocal * 16 + droop * 30,
      );

      final ctrl1 = Offset(attach.dx + dir * leafSize * 0.4, attach.dy - leafSize * 0.5 * sizeMod);
      final ctrl2 = Offset(attach.dx + dir * leafSize * 0.7, tip.dy - leafSize * 0.3 * sizeMod);

      final path = Path()
        ..moveTo(attach.dx, attach.dy)
        ..cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, tip.dx, tip.dy)
        ..cubicTo(
          tip.dx - dir * leafSize * 0.2, tip.dy + leafSize * 0.4,
          attach.dx + dir * leafSize * 0.3, attach.dy + leafSize * 0.4,
          attach.dx, attach.dy,
        )
        ..close();
      canvas.drawPath(path, Paint()..color = p.leaf);

      canvas.drawPath(
        Path()
          ..moveTo(attach.dx, attach.dy)
          ..quadraticBezierTo(ctrl1.dx, ctrl1.dy, tip.dx, tip.dy),
        Paint()
          ..color = p.stem.withOpacity(0.5)
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke,
      );
    }
  }

  void _drawTopBud(Canvas canvas, double cx, double h, _Palette p) {
    final budY = h * 0.30;
    final budX = cx + math.sin(sway * math.pi * 2) * 6;
    canvas.drawCircle(Offset(budX, budY), 6, Paint()..color = p.leaf);
  }

  // ── FLOWERING: Tepedeki çiçek ────────────────────────────────────────────
  void _drawFlower(Canvas canvas, double cx, double h, _Palette p) {
    final fy = h * 0.30;
    final fx = cx + math.sin(sway * math.pi * 2) * 6;
    final petalPaint = Paint()..color = p.flower;
    final centerPaint = Paint()..color = const Color(0xFFFFE38A);

    // 5 yaprak — hafif rotation animasyonu
    final rot = sway * math.pi * 2 * 0.05;
    for (int i = 0; i < 5; i++) {
      final a = rot + i * (math.pi * 2 / 5);
      final px = fx + math.cos(a) * 12;
      final py = fy + math.sin(a) * 12;
      canvas.drawCircle(Offset(px, py), 9, petalPaint);
    }
    canvas.drawCircle(Offset(fx, fy), 6, centerPaint);
  }

  // ── SUCCULENT / KAKTÜS ───────────────────────────────────────────────────
  void _drawSucculent(Canvas canvas, double cx, double h, _Palette p) {
    final sway2 = math.sin(sway * math.pi * 2) * (mood == PlantMood.watering ? 4 : 2);
    final baseY = h * 0.70;

    // 3 dik kalın gövde — orta + iki yan
    _drawCactusBody(canvas, cx + sway2 * 0.4, baseY, baseHeight: h * 0.42, baseWidth: 38, palette: p);
    _drawCactusBody(canvas, cx - 28, baseY, baseHeight: h * 0.28, baseWidth: 22, palette: p, lean: -0.15);
    _drawCactusBody(canvas, cx + 28, baseY, baseHeight: h * 0.30, baseWidth: 22, palette: p, lean: 0.15);

    // Kaktüs çiçeği — sağlıklıyken göster
    if (mood == PlantMood.thriving || mood == PlantMood.brightLight) {
      final fx = cx + sway2 * 0.4;
      final fy = baseY - h * 0.42;
      canvas.drawCircle(Offset(fx, fy - 6), 7, Paint()..color = const Color(0xFFFFB8C5));
      canvas.drawCircle(Offset(fx, fy - 6), 3, Paint()..color = const Color(0xFFFFE38A));
    }
  }

  void _drawCactusBody(
    Canvas canvas,
    double cx,
    double baseY, {
    required double baseHeight,
    required double baseWidth,
    required _Palette palette,
    double lean = 0,
  }) {
    final topY = baseY - baseHeight;
    final tipX = cx + lean * baseHeight;

    final body = Path()
      ..moveTo(cx - baseWidth / 2, baseY)
      ..quadraticBezierTo(
        cx - baseWidth / 2 - 4, baseY - baseHeight * 0.5,
        tipX - baseWidth / 3, topY,
      )
      ..quadraticBezierTo(tipX, topY - 8, tipX + baseWidth / 3, topY)
      ..quadraticBezierTo(
        cx + baseWidth / 2 + 4, baseY - baseHeight * 0.5,
        cx + baseWidth / 2, baseY,
      )
      ..close();
    canvas.drawPath(body, Paint()..color = palette.leaf);

    // Dikenler — küçük çapraz çizgiler
    final spinePaint = Paint()
      ..color = palette.stem.withOpacity(0.7)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final spineCount = (baseHeight / 14).floor();
    for (int i = 1; i <= spineCount; i++) {
      final ratio = i / (spineCount + 1);
      final y = baseY - baseHeight * ratio;
      final x1 = cx - baseWidth * 0.35 + lean * baseHeight * ratio;
      final x2 = cx + baseWidth * 0.35 + lean * baseHeight * ratio;
      canvas.drawLine(Offset(x1 - 3, y - 2), Offset(x1 + 1, y + 2), spinePaint);
      canvas.drawLine(Offset(x2 - 1, y - 2), Offset(x2 + 3, y + 2), spinePaint);
    }
  }

  // ── Sulama damlaları ─────────────────────────────────────────────────────
  void _drawWaterDrops(Canvas canvas, double cx, double h) {
    final dropPaint = Paint()..color = const Color(0xFF89C5E8).withOpacity(0.85);
    for (int i = 0; i < 5; i++) {
      final phase = (drops + i * 0.2) % 1.0;
      final x = cx + (i - 2) * 18;
      final y = h * 0.20 + phase * h * 0.45;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 6, height: 9),
        dropPaint,
      );
    }
  }

  void _drawSunOverlay(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFFFFE8A8).withOpacity(0.5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(w * 0.8, h * 0.15), radius: w * 0.4));
    canvas.drawCircle(Offset(w * 0.8, h * 0.15), w * 0.4, paint);
  }

  void _drawShadowOverlay(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black.withOpacity(0.18), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
  }

  @override
  bool shouldRepaint(covariant _PlantPainter old) =>
      old.sway != sway ||
      old.breathe != breathe ||
      old.drops != drops ||
      old.mood != mood ||
      old.shape != shape;
}

class _Palette {
  _Palette({
    required this.leaf,
    required this.stem,
    required this.pot,
    required this.soil,
    required this.glow,
    required this.flower,
  });
  final Color leaf;
  final Color stem;
  final Color pot;
  final Color soil;
  final Color glow;
  final Color flower;
}

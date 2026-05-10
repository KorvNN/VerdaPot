import 'package:flutter/material.dart';

/// Verdapot tasarım sistemi — pastel + glassmorphism üzerine kurulu.
class VerdapotTheme {
  static const String appName = 'VerdaPot';

  // ── Pastel Paleti ──────────────────────────────────────────────────────────
  static const Color sage      = Color(0xFFB8D9C0);   // ana yeşil
  static const Color mint      = Color(0xFFD4F0DD);   // açık yeşil
  static const Color blush     = Color(0xFFFAD7C9);   // pastel pembe
  static const Color sky       = Color(0xFFCDE5F2);   // pastel mavi
  static const Color cream     = Color(0xFFFAF4E8);   // krem zemin
  static const Color sand      = Color(0xFFEFE3D2);   // saksı toprağı
  static const Color terracotta= Color(0xFFD4A28A);   // saksı
  static const Color charcoal  = Color(0xFF2D3A35);   // koyu yazı
  static const Color slate     = Color(0xFF6B7C75);   // ikincil yazı

  // Durum renkleri (pastel ama ayrılabilir)
  static const Color statusOk      = Color(0xFF8BC4A0);
  static const Color statusWarning = Color(0xFFE8B86A);
  static const Color statusAlert   = Color(0xFFE8908A);
  static const Color statusOffline = Color(0xFF9CA8A4);

  // ── Arka Plan Gradient'i (tüm ekranlarda) ──────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF6F3EC),  // krem
      Color(0xFFE8F1EC),  // çok açık nane
      Color(0xFFEFE7F0),  // açık leylak
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ── Glass Kart Stili ───────────────────────────────────────────────────────
  static BoxDecoration glassCard({double radius = 24, Color? tint}) {
    return BoxDecoration(
      color: (tint ?? Colors.white).withOpacity(0.55),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: Colors.white.withOpacity(0.7),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: charcoal.withOpacity(0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  // ── ThemeData ──────────────────────────────────────────────────────────────
  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sage,
        brightness: Brightness.light,
        primary: sage,
        secondary: blush,
        surface: cream,
        onSurface: charcoal,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: charcoal,
        displayColor: charcoal,
        fontFamily: 'Roboto',
      ).copyWith(
        displayLarge: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300, letterSpacing: -1.5),
        headlineSmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.3),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: charcoal),
        titleTextStyle: TextStyle(
          color: charcoal,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white70,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: charcoal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3),
        ),
      ),
      iconTheme: const IconThemeData(color: charcoal),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tüm ekranlarda kullanılan glassmorphic üst container.
/// Solda VerdaPot logosu + ekran başlığı, sağda opsiyonel aksiyon butonları.
/// Standart AppBar yerine PreferredSize + BackdropFilter ile cam efektli kart
/// olarak çizilir; sayfanın üst kısmında "yüzen" bir görünüm verir.
PreferredSizeWidget appHeader({
  required String title,
  List<Widget>? actions,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(76),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: VerdapotTheme.charcoal.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(children: [
                const _Logo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: VerdapotTheme.charcoal,
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (actions != null) ...actions,
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VerdapotTheme.sage, VerdapotTheme.mint],
        ),
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: VerdapotTheme.sage.withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(Icons.eco, color: Colors.white, size: 20),
    );
  }
}

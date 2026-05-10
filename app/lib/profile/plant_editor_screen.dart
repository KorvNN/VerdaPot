import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/glass_card.dart';

/// Özel bitki tanımlama formu. Fuzzy logic'in ihtiyacı olan tüm eşikler
/// kullanıcıya açık etiketlerle sunulur ve temel min/max tutarlılığı kontrol
/// edilir.
class PlantEditorScreen extends ConsumerStatefulWidget {
  const PlantEditorScreen({super.key});

  @override
  ConsumerState<PlantEditorScreen> createState() => _PlantEditorScreenState();
}

class _PlantEditorScreenState extends ConsumerState<PlantEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl    = TextEditingController();
  final _tMinCtrl    = TextEditingController(text: '18');
  final _tMaxCtrl    = TextEditingController(text: '24');
  final _tStresCtrl  = TextEditingController(text: '4');
  final _rhMinCtrl   = TextEditingController(text: '50');
  final _rhMaxCtrl   = TextEditingController(text: '70');
  final _toprakCtrl  = TextEditingController(text: '45');
  final _sureMaxCtrl = TextEditingController(text: '4');
  final _luxMinCtrl  = TextEditingController(text: '807');
  final _luxMaxCtrl  = TextEditingController(text: '10764');

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _tMinCtrl, _tMaxCtrl, _tStresCtrl, _rhMinCtrl, _rhMaxCtrl,
      _toprakCtrl, _sureMaxCtrl, _luxMinCtrl, _luxMaxCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appHeader(title: 'Özel Bitki'),
      body: Container(
        decoration: const BoxDecoration(gradient: VerdapotTheme.backgroundGradient),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 32),
              children: [
                GlassCard(
                  child: _text(_nameCtrl, 'Bitki Adı', required: true),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'SICAKLIK (°C)',
                  child: Row(children: [
                    Expanded(child: _num(_tMinCtrl, 'Min')),
                    const SizedBox(width: 10),
                    Expanded(child: _num(_tMaxCtrl, 'Max')),
                    const SizedBox(width: 10),
                    Expanded(child: _num(_tStresCtrl, 'Stres')),
                  ]),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'HAVA NEMİ (%)',
                  child: Row(children: [
                    Expanded(child: _num(_rhMinCtrl, 'Min')),
                    const SizedBox(width: 10),
                    Expanded(child: _num(_rhMaxCtrl, 'Max')),
                  ]),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'TOPRAK',
                  subtitle: 'Bu yüzdenin altına düşünce sulama düşünülür',
                  child: _num(_toprakCtrl, 'Kuru eşik (%)'),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'SULAMA',
                  subtitle: 'Fuzzy bunun yüzdesi kadar sular',
                  child: _num(_sureMaxCtrl, 'Maksimum süre (sn)'),
                ),
                const SizedBox(height: 14),
                _Section(
                  title: 'IŞIK (lux)',
                  child: Row(children: [
                    Expanded(child: _num(_luxMinCtrl, 'Min')),
                    const SizedBox(width: 10),
                    Expanded(child: _num(_luxMaxCtrl, 'Max')),
                  ]),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Form alanları ────────────────────────────────────────────────────────
  Widget _text(TextEditingController c, String label, {bool required = false}) {
    return TextFormField(
      controller: c,
      decoration: _inputDecoration(label),
      validator: (v) {
        if (required && (v == null || v.trim().isEmpty)) return 'Zorunlu';
        return null;
      },
    );
  }

  Widget _num(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _inputDecoration(label),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Zorunlu';
        if (double.tryParse(v.replaceAll(',', '.')) == null) return 'Sayı';
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: VerdapotTheme.slate, fontSize: 13),
      filled: true,
      fillColor: VerdapotTheme.cream.withOpacity(0.7),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ── Kaydetme + validasyon ────────────────────────────────────────────────
  double _d(TextEditingController c) => double.parse(c.text.replaceAll(',', '.'));
  int _i(TextEditingController c) => int.parse(c.text.trim());

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_d(_tMinCtrl) >= _d(_tMaxCtrl)) {
      _showError('Sıcaklık min < max olmalı');
      return;
    }
    if (_d(_rhMinCtrl) >= _d(_rhMaxCtrl)) {
      _showError('Nem min < max olmalı');
      return;
    }
    if (_i(_luxMinCtrl) >= _i(_luxMaxCtrl)) {
      _showError('Işık min < max olmalı');
      return;
    }
    if (_i(_sureMaxCtrl) < 1 || _i(_sureMaxCtrl) > 30) {
      _showError('Sulama süresi 1–30 sn arasında olmalı');
      return;
    }

    final entry = PlantProfilesCompanion(
      bitkiAdi:        Value(_nameCtrl.text.trim()),
      sicaklikMin:     Value(_d(_tMinCtrl)),
      sicaklikMax:     Value(_d(_tMaxCtrl)),
      sicaklikStres:   Value(_d(_tStresCtrl)),
      nemMin:          Value(_d(_rhMinCtrl)),
      nemMax:          Value(_d(_rhMaxCtrl)),
      toprakKuruEsik:  Value(_d(_toprakCtrl)),
      sulamaSureMax:   Value(_i(_sureMaxCtrl)),
      isikMin:         Value(_i(_luxMinCtrl)),
      isikMax:         Value(_i(_luxMaxCtrl)),
    );

    await ref.read(profileRepoProvider).insertCustom(entry);
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.subtitle});
  final String title;
  final String? subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: VerdapotTheme.slate,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: VerdapotTheme.slate),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

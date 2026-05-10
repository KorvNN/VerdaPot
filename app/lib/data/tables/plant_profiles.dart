import 'package:drift/drift.dart';

/// Bitki profili — fuzzy logic'in ihtiyacı olan tüm eşikleri tek satırda tutar.
/// Bu satırın alanları doğrudan ESP32'ye `/cmd/set_profile` gövdesi olarak gider.
class PlantProfiles extends Table {
  IntColumn  get id              => integer().autoIncrement()();
  TextColumn get bitkiAdi        => text()();                 // örn: "Monstera"
  TextColumn get bitkiAdiTr      => text().nullable()();      // örn: "Monstera"

  // Sıcaklık konfor aralığı
  RealColumn get sicaklikMin     => real()();                 // °C
  RealColumn get sicaklikMax     => real()();                 // °C
  RealColumn get sicaklikStres   => real()();                 // fuzzy stres marjı (°C)

  // Hava nemi konfor aralığı
  RealColumn get nemMin          => real()();                 // %
  RealColumn get nemMax          => real()();                 // %

  // Toprak nem eşiği — bu altına düşünce sulama düşünülür
  RealColumn get toprakKuruEsik  => real()();                 // %

  // Sulama tavanı (fuzzy bunun yüzdesi kadar sular)
  IntColumn  get sulamaSureMax   => integer()();              // saniye

  // Işık alarm sınırları
  IntColumn  get isikMin         => integer()();              // lux
  IntColumn  get isikMax         => integer()();              // lux

  // Meta
  BoolColumn get isPreset        => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive        => boolean().withDefault(const Constant(false))();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _macMeta = const VerificationMeta('mac');
  @override
  late final GeneratedColumn<String> mac = GeneratedColumn<String>(
      'mac', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSeenAtMeta =
      const VerificationMeta('lastSeenAt');
  @override
  late final GeneratedColumn<int> lastSeenAt = GeneratedColumn<int>(
      'last_seen_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, mac, token, lastSeenAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mac')) {
      context.handle(
          _macMeta, mac.isAcceptableOrUnknown(data['mac']!, _macMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
          _lastSeenAtMeta,
          lastSeenAt.isAcceptableOrUnknown(
              data['last_seen_at']!, _lastSeenAtMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mac: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mac']),
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      lastSeenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_seen_at']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String name;
  final String? mac;
  final String? token;
  final int? lastSeenAt;
  final bool isActive;
  const Device(
      {required this.id,
      required this.name,
      this.mac,
      this.token,
      this.lastSeenAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mac != null) {
      map['mac'] = Variable<String>(mac);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<int>(lastSeenAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      name: Value(name),
      mac: mac == null && nullToAbsent ? const Value.absent() : Value(mac),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      isActive: Value(isActive),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mac: serializer.fromJson<String?>(json['mac']),
      token: serializer.fromJson<String?>(json['token']),
      lastSeenAt: serializer.fromJson<int?>(json['lastSeenAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'mac': serializer.toJson<String?>(mac),
      'token': serializer.toJson<String?>(token),
      'lastSeenAt': serializer.toJson<int?>(lastSeenAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Device copyWith(
          {int? id,
          String? name,
          Value<String?> mac = const Value.absent(),
          Value<String?> token = const Value.absent(),
          Value<int?> lastSeenAt = const Value.absent(),
          bool? isActive}) =>
      Device(
        id: id ?? this.id,
        name: name ?? this.name,
        mac: mac.present ? mac.value : this.mac,
        token: token.present ? token.value : this.token,
        lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
        isActive: isActive ?? this.isActive,
      );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mac: data.mac.present ? data.mac.value : this.mac,
      token: data.token.present ? data.token.value : this.token,
      lastSeenAt:
          data.lastSeenAt.present ? data.lastSeenAt.value : this.lastSeenAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mac: $mac, ')
          ..write('token: $token, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mac, token, lastSeenAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.name == this.name &&
          other.mac == this.mac &&
          other.token == this.token &&
          other.lastSeenAt == this.lastSeenAt &&
          other.isActive == this.isActive);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> mac;
  final Value<String?> token;
  final Value<int?> lastSeenAt;
  final Value<bool> isActive;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mac = const Value.absent(),
    this.token = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.mac = const Value.absent(),
    this.token = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Device> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mac,
    Expression<String>? token,
    Expression<int>? lastSeenAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mac != null) 'mac': mac,
      if (token != null) 'token': token,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  DevicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? mac,
      Value<String?>? token,
      Value<int?>? lastSeenAt,
      Value<bool>? isActive}) {
    return DevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mac: mac ?? this.mac,
      token: token ?? this.token,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mac.present) {
      map['mac'] = Variable<String>(mac.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<int>(lastSeenAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mac: $mac, ')
          ..write('token: $token, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SensorReadingsTable extends SensorReadings
    with TableInfo<$SensorReadingsTable, SensorReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SensorReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices (id)'));
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
      'ts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _temperatureCMeta =
      const VerificationMeta('temperatureC');
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
      'temperature_c', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _humidityPctMeta =
      const VerificationMeta('humidityPct');
  @override
  late final GeneratedColumn<double> humidityPct = GeneratedColumn<double>(
      'humidity_pct', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _soilMoistureMeta =
      const VerificationMeta('soilMoisture');
  @override
  late final GeneratedColumn<int> soilMoisture = GeneratedColumn<int>(
      'soil_moisture', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lightLuxMeta =
      const VerificationMeta('lightLux');
  @override
  late final GeneratedColumn<int> lightLux = GeneratedColumn<int>(
      'light_lux', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pumpActiveMeta =
      const VerificationMeta('pumpActive');
  @override
  late final GeneratedColumn<bool> pumpActive = GeneratedColumn<bool>(
      'pump_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pump_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bitkiAdiMeta =
      const VerificationMeta('bitkiAdi');
  @override
  late final GeneratedColumn<String> bitkiAdi = GeneratedColumn<String>(
      'bitki_adi', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deviceId,
        ts,
        temperatureC,
        humidityPct,
        soilMoisture,
        lightLux,
        pumpActive,
        bitkiAdi
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sensor_readings';
  @override
  VerificationContext validateIntegrity(Insertable<SensorReading> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
          _temperatureCMeta,
          temperatureC.isAcceptableOrUnknown(
              data['temperature_c']!, _temperatureCMeta));
    }
    if (data.containsKey('humidity_pct')) {
      context.handle(
          _humidityPctMeta,
          humidityPct.isAcceptableOrUnknown(
              data['humidity_pct']!, _humidityPctMeta));
    }
    if (data.containsKey('soil_moisture')) {
      context.handle(
          _soilMoistureMeta,
          soilMoisture.isAcceptableOrUnknown(
              data['soil_moisture']!, _soilMoistureMeta));
    }
    if (data.containsKey('light_lux')) {
      context.handle(_lightLuxMeta,
          lightLux.isAcceptableOrUnknown(data['light_lux']!, _lightLuxMeta));
    }
    if (data.containsKey('pump_active')) {
      context.handle(
          _pumpActiveMeta,
          pumpActive.isAcceptableOrUnknown(
              data['pump_active']!, _pumpActiveMeta));
    }
    if (data.containsKey('bitki_adi')) {
      context.handle(_bitkiAdiMeta,
          bitkiAdi.isAcceptableOrUnknown(data['bitki_adi']!, _bitkiAdiMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SensorReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SensorReading(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ts'])!,
      temperatureC: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temperature_c']),
      humidityPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}humidity_pct']),
      soilMoisture: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}soil_moisture']),
      lightLux: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}light_lux']),
      pumpActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pump_active'])!,
      bitkiAdi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bitki_adi']),
    );
  }

  @override
  $SensorReadingsTable createAlias(String alias) {
    return $SensorReadingsTable(attachedDatabase, alias);
  }
}

class SensorReading extends DataClass implements Insertable<SensorReading> {
  final int id;
  final int deviceId;
  final int ts;
  final double? temperatureC;
  final double? humidityPct;
  final int? soilMoisture;
  final int? lightLux;
  final bool pumpActive;
  final String? bitkiAdi;
  const SensorReading(
      {required this.id,
      required this.deviceId,
      required this.ts,
      this.temperatureC,
      this.humidityPct,
      this.soilMoisture,
      this.lightLux,
      required this.pumpActive,
      this.bitkiAdi});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<int>(deviceId);
    map['ts'] = Variable<int>(ts);
    if (!nullToAbsent || temperatureC != null) {
      map['temperature_c'] = Variable<double>(temperatureC);
    }
    if (!nullToAbsent || humidityPct != null) {
      map['humidity_pct'] = Variable<double>(humidityPct);
    }
    if (!nullToAbsent || soilMoisture != null) {
      map['soil_moisture'] = Variable<int>(soilMoisture);
    }
    if (!nullToAbsent || lightLux != null) {
      map['light_lux'] = Variable<int>(lightLux);
    }
    map['pump_active'] = Variable<bool>(pumpActive);
    if (!nullToAbsent || bitkiAdi != null) {
      map['bitki_adi'] = Variable<String>(bitkiAdi);
    }
    return map;
  }

  SensorReadingsCompanion toCompanion(bool nullToAbsent) {
    return SensorReadingsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      ts: Value(ts),
      temperatureC: temperatureC == null && nullToAbsent
          ? const Value.absent()
          : Value(temperatureC),
      humidityPct: humidityPct == null && nullToAbsent
          ? const Value.absent()
          : Value(humidityPct),
      soilMoisture: soilMoisture == null && nullToAbsent
          ? const Value.absent()
          : Value(soilMoisture),
      lightLux: lightLux == null && nullToAbsent
          ? const Value.absent()
          : Value(lightLux),
      pumpActive: Value(pumpActive),
      bitkiAdi: bitkiAdi == null && nullToAbsent
          ? const Value.absent()
          : Value(bitkiAdi),
    );
  }

  factory SensorReading.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SensorReading(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      ts: serializer.fromJson<int>(json['ts']),
      temperatureC: serializer.fromJson<double?>(json['temperatureC']),
      humidityPct: serializer.fromJson<double?>(json['humidityPct']),
      soilMoisture: serializer.fromJson<int?>(json['soilMoisture']),
      lightLux: serializer.fromJson<int?>(json['lightLux']),
      pumpActive: serializer.fromJson<bool>(json['pumpActive']),
      bitkiAdi: serializer.fromJson<String?>(json['bitkiAdi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<int>(deviceId),
      'ts': serializer.toJson<int>(ts),
      'temperatureC': serializer.toJson<double?>(temperatureC),
      'humidityPct': serializer.toJson<double?>(humidityPct),
      'soilMoisture': serializer.toJson<int?>(soilMoisture),
      'lightLux': serializer.toJson<int?>(lightLux),
      'pumpActive': serializer.toJson<bool>(pumpActive),
      'bitkiAdi': serializer.toJson<String?>(bitkiAdi),
    };
  }

  SensorReading copyWith(
          {int? id,
          int? deviceId,
          int? ts,
          Value<double?> temperatureC = const Value.absent(),
          Value<double?> humidityPct = const Value.absent(),
          Value<int?> soilMoisture = const Value.absent(),
          Value<int?> lightLux = const Value.absent(),
          bool? pumpActive,
          Value<String?> bitkiAdi = const Value.absent()}) =>
      SensorReading(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        ts: ts ?? this.ts,
        temperatureC:
            temperatureC.present ? temperatureC.value : this.temperatureC,
        humidityPct: humidityPct.present ? humidityPct.value : this.humidityPct,
        soilMoisture:
            soilMoisture.present ? soilMoisture.value : this.soilMoisture,
        lightLux: lightLux.present ? lightLux.value : this.lightLux,
        pumpActive: pumpActive ?? this.pumpActive,
        bitkiAdi: bitkiAdi.present ? bitkiAdi.value : this.bitkiAdi,
      );
  SensorReading copyWithCompanion(SensorReadingsCompanion data) {
    return SensorReading(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      ts: data.ts.present ? data.ts.value : this.ts,
      temperatureC: data.temperatureC.present
          ? data.temperatureC.value
          : this.temperatureC,
      humidityPct:
          data.humidityPct.present ? data.humidityPct.value : this.humidityPct,
      soilMoisture: data.soilMoisture.present
          ? data.soilMoisture.value
          : this.soilMoisture,
      lightLux: data.lightLux.present ? data.lightLux.value : this.lightLux,
      pumpActive:
          data.pumpActive.present ? data.pumpActive.value : this.pumpActive,
      bitkiAdi: data.bitkiAdi.present ? data.bitkiAdi.value : this.bitkiAdi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SensorReading(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('ts: $ts, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPct: $humidityPct, ')
          ..write('soilMoisture: $soilMoisture, ')
          ..write('lightLux: $lightLux, ')
          ..write('pumpActive: $pumpActive, ')
          ..write('bitkiAdi: $bitkiAdi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, ts, temperatureC, humidityPct,
      soilMoisture, lightLux, pumpActive, bitkiAdi);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorReading &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.ts == this.ts &&
          other.temperatureC == this.temperatureC &&
          other.humidityPct == this.humidityPct &&
          other.soilMoisture == this.soilMoisture &&
          other.lightLux == this.lightLux &&
          other.pumpActive == this.pumpActive &&
          other.bitkiAdi == this.bitkiAdi);
}

class SensorReadingsCompanion extends UpdateCompanion<SensorReading> {
  final Value<int> id;
  final Value<int> deviceId;
  final Value<int> ts;
  final Value<double?> temperatureC;
  final Value<double?> humidityPct;
  final Value<int?> soilMoisture;
  final Value<int?> lightLux;
  final Value<bool> pumpActive;
  final Value<String?> bitkiAdi;
  const SensorReadingsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.ts = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.humidityPct = const Value.absent(),
    this.soilMoisture = const Value.absent(),
    this.lightLux = const Value.absent(),
    this.pumpActive = const Value.absent(),
    this.bitkiAdi = const Value.absent(),
  });
  SensorReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int deviceId,
    required int ts,
    this.temperatureC = const Value.absent(),
    this.humidityPct = const Value.absent(),
    this.soilMoisture = const Value.absent(),
    this.lightLux = const Value.absent(),
    this.pumpActive = const Value.absent(),
    this.bitkiAdi = const Value.absent(),
  })  : deviceId = Value(deviceId),
        ts = Value(ts);
  static Insertable<SensorReading> custom({
    Expression<int>? id,
    Expression<int>? deviceId,
    Expression<int>? ts,
    Expression<double>? temperatureC,
    Expression<double>? humidityPct,
    Expression<int>? soilMoisture,
    Expression<int>? lightLux,
    Expression<bool>? pumpActive,
    Expression<String>? bitkiAdi,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (ts != null) 'ts': ts,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (humidityPct != null) 'humidity_pct': humidityPct,
      if (soilMoisture != null) 'soil_moisture': soilMoisture,
      if (lightLux != null) 'light_lux': lightLux,
      if (pumpActive != null) 'pump_active': pumpActive,
      if (bitkiAdi != null) 'bitki_adi': bitkiAdi,
    });
  }

  SensorReadingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? deviceId,
      Value<int>? ts,
      Value<double?>? temperatureC,
      Value<double?>? humidityPct,
      Value<int?>? soilMoisture,
      Value<int?>? lightLux,
      Value<bool>? pumpActive,
      Value<String?>? bitkiAdi}) {
    return SensorReadingsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      ts: ts ?? this.ts,
      temperatureC: temperatureC ?? this.temperatureC,
      humidityPct: humidityPct ?? this.humidityPct,
      soilMoisture: soilMoisture ?? this.soilMoisture,
      lightLux: lightLux ?? this.lightLux,
      pumpActive: pumpActive ?? this.pumpActive,
      bitkiAdi: bitkiAdi ?? this.bitkiAdi,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (humidityPct.present) {
      map['humidity_pct'] = Variable<double>(humidityPct.value);
    }
    if (soilMoisture.present) {
      map['soil_moisture'] = Variable<int>(soilMoisture.value);
    }
    if (lightLux.present) {
      map['light_lux'] = Variable<int>(lightLux.value);
    }
    if (pumpActive.present) {
      map['pump_active'] = Variable<bool>(pumpActive.value);
    }
    if (bitkiAdi.present) {
      map['bitki_adi'] = Variable<String>(bitkiAdi.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SensorReadingsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('ts: $ts, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPct: $humidityPct, ')
          ..write('soilMoisture: $soilMoisture, ')
          ..write('lightLux: $lightLux, ')
          ..write('pumpActive: $pumpActive, ')
          ..write('bitkiAdi: $bitkiAdi')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices (id)'));
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
      'ts', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, deviceId, ts, kind, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      ts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ts'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int deviceId;
  final int ts;
  final String kind;
  final String? payload;
  const Event(
      {required this.id,
      required this.deviceId,
      required this.ts,
      required this.kind,
      this.payload});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<int>(deviceId);
    map['ts'] = Variable<int>(ts);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      ts: Value(ts),
      kind: Value(kind),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      ts: serializer.fromJson<int>(json['ts']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String?>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<int>(deviceId),
      'ts': serializer.toJson<int>(ts),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String?>(payload),
    };
  }

  Event copyWith(
          {int? id,
          int? deviceId,
          int? ts,
          String? kind,
          Value<String?> payload = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        ts: ts ?? this.ts,
        kind: kind ?? this.kind,
        payload: payload.present ? payload.value : this.payload,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      ts: data.ts.present ? data.ts.value : this.ts,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('ts: $ts, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, ts, kind, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.ts == this.ts &&
          other.kind == this.kind &&
          other.payload == this.payload);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> deviceId;
  final Value<int> ts;
  final Value<String> kind;
  final Value<String?> payload;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.ts = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int deviceId,
    required int ts,
    required String kind,
    this.payload = const Value.absent(),
  })  : deviceId = Value(deviceId),
        ts = Value(ts),
        kind = Value(kind);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? deviceId,
    Expression<int>? ts,
    Expression<String>? kind,
    Expression<String>? payload,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (ts != null) 'ts': ts,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<int>? deviceId,
      Value<int>? ts,
      Value<String>? kind,
      Value<String?>? payload}) {
    return EventsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      ts: ts ?? this.ts,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('ts: $ts, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }
}

class $PlantProfilesTable extends PlantProfiles
    with TableInfo<$PlantProfilesTable, PlantProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bitkiAdiMeta =
      const VerificationMeta('bitkiAdi');
  @override
  late final GeneratedColumn<String> bitkiAdi = GeneratedColumn<String>(
      'bitki_adi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bitkiAdiTrMeta =
      const VerificationMeta('bitkiAdiTr');
  @override
  late final GeneratedColumn<String> bitkiAdiTr = GeneratedColumn<String>(
      'bitki_adi_tr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sicaklikMinMeta =
      const VerificationMeta('sicaklikMin');
  @override
  late final GeneratedColumn<double> sicaklikMin = GeneratedColumn<double>(
      'sicaklik_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sicaklikMaxMeta =
      const VerificationMeta('sicaklikMax');
  @override
  late final GeneratedColumn<double> sicaklikMax = GeneratedColumn<double>(
      'sicaklik_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sicaklikStresMeta =
      const VerificationMeta('sicaklikStres');
  @override
  late final GeneratedColumn<double> sicaklikStres = GeneratedColumn<double>(
      'sicaklik_stres', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nemMinMeta = const VerificationMeta('nemMin');
  @override
  late final GeneratedColumn<double> nemMin = GeneratedColumn<double>(
      'nem_min', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nemMaxMeta = const VerificationMeta('nemMax');
  @override
  late final GeneratedColumn<double> nemMax = GeneratedColumn<double>(
      'nem_max', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _toprakKuruEsikMeta =
      const VerificationMeta('toprakKuruEsik');
  @override
  late final GeneratedColumn<double> toprakKuruEsik = GeneratedColumn<double>(
      'toprak_kuru_esik', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sulamaSureMaxMeta =
      const VerificationMeta('sulamaSureMax');
  @override
  late final GeneratedColumn<int> sulamaSureMax = GeneratedColumn<int>(
      'sulama_sure_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isikMinMeta =
      const VerificationMeta('isikMin');
  @override
  late final GeneratedColumn<int> isikMin = GeneratedColumn<int>(
      'isik_min', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isikMaxMeta =
      const VerificationMeta('isikMax');
  @override
  late final GeneratedColumn<int> isikMax = GeneratedColumn<int>(
      'isik_max', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isPresetMeta =
      const VerificationMeta('isPreset');
  @override
  late final GeneratedColumn<bool> isPreset = GeneratedColumn<bool>(
      'is_preset', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_preset" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bitkiAdi,
        bitkiAdiTr,
        sicaklikMin,
        sicaklikMax,
        sicaklikStres,
        nemMin,
        nemMax,
        toprakKuruEsik,
        sulamaSureMax,
        isikMin,
        isikMax,
        isPreset,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plant_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PlantProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bitki_adi')) {
      context.handle(_bitkiAdiMeta,
          bitkiAdi.isAcceptableOrUnknown(data['bitki_adi']!, _bitkiAdiMeta));
    } else if (isInserting) {
      context.missing(_bitkiAdiMeta);
    }
    if (data.containsKey('bitki_adi_tr')) {
      context.handle(
          _bitkiAdiTrMeta,
          bitkiAdiTr.isAcceptableOrUnknown(
              data['bitki_adi_tr']!, _bitkiAdiTrMeta));
    }
    if (data.containsKey('sicaklik_min')) {
      context.handle(
          _sicaklikMinMeta,
          sicaklikMin.isAcceptableOrUnknown(
              data['sicaklik_min']!, _sicaklikMinMeta));
    } else if (isInserting) {
      context.missing(_sicaklikMinMeta);
    }
    if (data.containsKey('sicaklik_max')) {
      context.handle(
          _sicaklikMaxMeta,
          sicaklikMax.isAcceptableOrUnknown(
              data['sicaklik_max']!, _sicaklikMaxMeta));
    } else if (isInserting) {
      context.missing(_sicaklikMaxMeta);
    }
    if (data.containsKey('sicaklik_stres')) {
      context.handle(
          _sicaklikStresMeta,
          sicaklikStres.isAcceptableOrUnknown(
              data['sicaklik_stres']!, _sicaklikStresMeta));
    } else if (isInserting) {
      context.missing(_sicaklikStresMeta);
    }
    if (data.containsKey('nem_min')) {
      context.handle(_nemMinMeta,
          nemMin.isAcceptableOrUnknown(data['nem_min']!, _nemMinMeta));
    } else if (isInserting) {
      context.missing(_nemMinMeta);
    }
    if (data.containsKey('nem_max')) {
      context.handle(_nemMaxMeta,
          nemMax.isAcceptableOrUnknown(data['nem_max']!, _nemMaxMeta));
    } else if (isInserting) {
      context.missing(_nemMaxMeta);
    }
    if (data.containsKey('toprak_kuru_esik')) {
      context.handle(
          _toprakKuruEsikMeta,
          toprakKuruEsik.isAcceptableOrUnknown(
              data['toprak_kuru_esik']!, _toprakKuruEsikMeta));
    } else if (isInserting) {
      context.missing(_toprakKuruEsikMeta);
    }
    if (data.containsKey('sulama_sure_max')) {
      context.handle(
          _sulamaSureMaxMeta,
          sulamaSureMax.isAcceptableOrUnknown(
              data['sulama_sure_max']!, _sulamaSureMaxMeta));
    } else if (isInserting) {
      context.missing(_sulamaSureMaxMeta);
    }
    if (data.containsKey('isik_min')) {
      context.handle(_isikMinMeta,
          isikMin.isAcceptableOrUnknown(data['isik_min']!, _isikMinMeta));
    } else if (isInserting) {
      context.missing(_isikMinMeta);
    }
    if (data.containsKey('isik_max')) {
      context.handle(_isikMaxMeta,
          isikMax.isAcceptableOrUnknown(data['isik_max']!, _isikMaxMeta));
    } else if (isInserting) {
      context.missing(_isikMaxMeta);
    }
    if (data.containsKey('is_preset')) {
      context.handle(_isPresetMeta,
          isPreset.isAcceptableOrUnknown(data['is_preset']!, _isPresetMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlantProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlantProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bitkiAdi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bitki_adi'])!,
      bitkiAdiTr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bitki_adi_tr']),
      sicaklikMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sicaklik_min'])!,
      sicaklikMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sicaklik_max'])!,
      sicaklikStres: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sicaklik_stres'])!,
      nemMin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nem_min'])!,
      nemMax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nem_max'])!,
      toprakKuruEsik: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}toprak_kuru_esik'])!,
      sulamaSureMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sulama_sure_max'])!,
      isikMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}isik_min'])!,
      isikMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}isik_max'])!,
      isPreset: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_preset'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $PlantProfilesTable createAlias(String alias) {
    return $PlantProfilesTable(attachedDatabase, alias);
  }
}

class PlantProfile extends DataClass implements Insertable<PlantProfile> {
  final int id;
  final String bitkiAdi;
  final String? bitkiAdiTr;
  final double sicaklikMin;
  final double sicaklikMax;
  final double sicaklikStres;
  final double nemMin;
  final double nemMax;
  final double toprakKuruEsik;
  final int sulamaSureMax;
  final int isikMin;
  final int isikMax;
  final bool isPreset;
  final bool isActive;
  const PlantProfile(
      {required this.id,
      required this.bitkiAdi,
      this.bitkiAdiTr,
      required this.sicaklikMin,
      required this.sicaklikMax,
      required this.sicaklikStres,
      required this.nemMin,
      required this.nemMax,
      required this.toprakKuruEsik,
      required this.sulamaSureMax,
      required this.isikMin,
      required this.isikMax,
      required this.isPreset,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bitki_adi'] = Variable<String>(bitkiAdi);
    if (!nullToAbsent || bitkiAdiTr != null) {
      map['bitki_adi_tr'] = Variable<String>(bitkiAdiTr);
    }
    map['sicaklik_min'] = Variable<double>(sicaklikMin);
    map['sicaklik_max'] = Variable<double>(sicaklikMax);
    map['sicaklik_stres'] = Variable<double>(sicaklikStres);
    map['nem_min'] = Variable<double>(nemMin);
    map['nem_max'] = Variable<double>(nemMax);
    map['toprak_kuru_esik'] = Variable<double>(toprakKuruEsik);
    map['sulama_sure_max'] = Variable<int>(sulamaSureMax);
    map['isik_min'] = Variable<int>(isikMin);
    map['isik_max'] = Variable<int>(isikMax);
    map['is_preset'] = Variable<bool>(isPreset);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  PlantProfilesCompanion toCompanion(bool nullToAbsent) {
    return PlantProfilesCompanion(
      id: Value(id),
      bitkiAdi: Value(bitkiAdi),
      bitkiAdiTr: bitkiAdiTr == null && nullToAbsent
          ? const Value.absent()
          : Value(bitkiAdiTr),
      sicaklikMin: Value(sicaklikMin),
      sicaklikMax: Value(sicaklikMax),
      sicaklikStres: Value(sicaklikStres),
      nemMin: Value(nemMin),
      nemMax: Value(nemMax),
      toprakKuruEsik: Value(toprakKuruEsik),
      sulamaSureMax: Value(sulamaSureMax),
      isikMin: Value(isikMin),
      isikMax: Value(isikMax),
      isPreset: Value(isPreset),
      isActive: Value(isActive),
    );
  }

  factory PlantProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlantProfile(
      id: serializer.fromJson<int>(json['id']),
      bitkiAdi: serializer.fromJson<String>(json['bitkiAdi']),
      bitkiAdiTr: serializer.fromJson<String?>(json['bitkiAdiTr']),
      sicaklikMin: serializer.fromJson<double>(json['sicaklikMin']),
      sicaklikMax: serializer.fromJson<double>(json['sicaklikMax']),
      sicaklikStres: serializer.fromJson<double>(json['sicaklikStres']),
      nemMin: serializer.fromJson<double>(json['nemMin']),
      nemMax: serializer.fromJson<double>(json['nemMax']),
      toprakKuruEsik: serializer.fromJson<double>(json['toprakKuruEsik']),
      sulamaSureMax: serializer.fromJson<int>(json['sulamaSureMax']),
      isikMin: serializer.fromJson<int>(json['isikMin']),
      isikMax: serializer.fromJson<int>(json['isikMax']),
      isPreset: serializer.fromJson<bool>(json['isPreset']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bitkiAdi': serializer.toJson<String>(bitkiAdi),
      'bitkiAdiTr': serializer.toJson<String?>(bitkiAdiTr),
      'sicaklikMin': serializer.toJson<double>(sicaklikMin),
      'sicaklikMax': serializer.toJson<double>(sicaklikMax),
      'sicaklikStres': serializer.toJson<double>(sicaklikStres),
      'nemMin': serializer.toJson<double>(nemMin),
      'nemMax': serializer.toJson<double>(nemMax),
      'toprakKuruEsik': serializer.toJson<double>(toprakKuruEsik),
      'sulamaSureMax': serializer.toJson<int>(sulamaSureMax),
      'isikMin': serializer.toJson<int>(isikMin),
      'isikMax': serializer.toJson<int>(isikMax),
      'isPreset': serializer.toJson<bool>(isPreset),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  PlantProfile copyWith(
          {int? id,
          String? bitkiAdi,
          Value<String?> bitkiAdiTr = const Value.absent(),
          double? sicaklikMin,
          double? sicaklikMax,
          double? sicaklikStres,
          double? nemMin,
          double? nemMax,
          double? toprakKuruEsik,
          int? sulamaSureMax,
          int? isikMin,
          int? isikMax,
          bool? isPreset,
          bool? isActive}) =>
      PlantProfile(
        id: id ?? this.id,
        bitkiAdi: bitkiAdi ?? this.bitkiAdi,
        bitkiAdiTr: bitkiAdiTr.present ? bitkiAdiTr.value : this.bitkiAdiTr,
        sicaklikMin: sicaklikMin ?? this.sicaklikMin,
        sicaklikMax: sicaklikMax ?? this.sicaklikMax,
        sicaklikStres: sicaklikStres ?? this.sicaklikStres,
        nemMin: nemMin ?? this.nemMin,
        nemMax: nemMax ?? this.nemMax,
        toprakKuruEsik: toprakKuruEsik ?? this.toprakKuruEsik,
        sulamaSureMax: sulamaSureMax ?? this.sulamaSureMax,
        isikMin: isikMin ?? this.isikMin,
        isikMax: isikMax ?? this.isikMax,
        isPreset: isPreset ?? this.isPreset,
        isActive: isActive ?? this.isActive,
      );
  PlantProfile copyWithCompanion(PlantProfilesCompanion data) {
    return PlantProfile(
      id: data.id.present ? data.id.value : this.id,
      bitkiAdi: data.bitkiAdi.present ? data.bitkiAdi.value : this.bitkiAdi,
      bitkiAdiTr:
          data.bitkiAdiTr.present ? data.bitkiAdiTr.value : this.bitkiAdiTr,
      sicaklikMin:
          data.sicaklikMin.present ? data.sicaklikMin.value : this.sicaklikMin,
      sicaklikMax:
          data.sicaklikMax.present ? data.sicaklikMax.value : this.sicaklikMax,
      sicaklikStres: data.sicaklikStres.present
          ? data.sicaklikStres.value
          : this.sicaklikStres,
      nemMin: data.nemMin.present ? data.nemMin.value : this.nemMin,
      nemMax: data.nemMax.present ? data.nemMax.value : this.nemMax,
      toprakKuruEsik: data.toprakKuruEsik.present
          ? data.toprakKuruEsik.value
          : this.toprakKuruEsik,
      sulamaSureMax: data.sulamaSureMax.present
          ? data.sulamaSureMax.value
          : this.sulamaSureMax,
      isikMin: data.isikMin.present ? data.isikMin.value : this.isikMin,
      isikMax: data.isikMax.present ? data.isikMax.value : this.isikMax,
      isPreset: data.isPreset.present ? data.isPreset.value : this.isPreset,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlantProfile(')
          ..write('id: $id, ')
          ..write('bitkiAdi: $bitkiAdi, ')
          ..write('bitkiAdiTr: $bitkiAdiTr, ')
          ..write('sicaklikMin: $sicaklikMin, ')
          ..write('sicaklikMax: $sicaklikMax, ')
          ..write('sicaklikStres: $sicaklikStres, ')
          ..write('nemMin: $nemMin, ')
          ..write('nemMax: $nemMax, ')
          ..write('toprakKuruEsik: $toprakKuruEsik, ')
          ..write('sulamaSureMax: $sulamaSureMax, ')
          ..write('isikMin: $isikMin, ')
          ..write('isikMax: $isikMax, ')
          ..write('isPreset: $isPreset, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      bitkiAdi,
      bitkiAdiTr,
      sicaklikMin,
      sicaklikMax,
      sicaklikStres,
      nemMin,
      nemMax,
      toprakKuruEsik,
      sulamaSureMax,
      isikMin,
      isikMax,
      isPreset,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlantProfile &&
          other.id == this.id &&
          other.bitkiAdi == this.bitkiAdi &&
          other.bitkiAdiTr == this.bitkiAdiTr &&
          other.sicaklikMin == this.sicaklikMin &&
          other.sicaklikMax == this.sicaklikMax &&
          other.sicaklikStres == this.sicaklikStres &&
          other.nemMin == this.nemMin &&
          other.nemMax == this.nemMax &&
          other.toprakKuruEsik == this.toprakKuruEsik &&
          other.sulamaSureMax == this.sulamaSureMax &&
          other.isikMin == this.isikMin &&
          other.isikMax == this.isikMax &&
          other.isPreset == this.isPreset &&
          other.isActive == this.isActive);
}

class PlantProfilesCompanion extends UpdateCompanion<PlantProfile> {
  final Value<int> id;
  final Value<String> bitkiAdi;
  final Value<String?> bitkiAdiTr;
  final Value<double> sicaklikMin;
  final Value<double> sicaklikMax;
  final Value<double> sicaklikStres;
  final Value<double> nemMin;
  final Value<double> nemMax;
  final Value<double> toprakKuruEsik;
  final Value<int> sulamaSureMax;
  final Value<int> isikMin;
  final Value<int> isikMax;
  final Value<bool> isPreset;
  final Value<bool> isActive;
  const PlantProfilesCompanion({
    this.id = const Value.absent(),
    this.bitkiAdi = const Value.absent(),
    this.bitkiAdiTr = const Value.absent(),
    this.sicaklikMin = const Value.absent(),
    this.sicaklikMax = const Value.absent(),
    this.sicaklikStres = const Value.absent(),
    this.nemMin = const Value.absent(),
    this.nemMax = const Value.absent(),
    this.toprakKuruEsik = const Value.absent(),
    this.sulamaSureMax = const Value.absent(),
    this.isikMin = const Value.absent(),
    this.isikMax = const Value.absent(),
    this.isPreset = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  PlantProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String bitkiAdi,
    this.bitkiAdiTr = const Value.absent(),
    required double sicaklikMin,
    required double sicaklikMax,
    required double sicaklikStres,
    required double nemMin,
    required double nemMax,
    required double toprakKuruEsik,
    required int sulamaSureMax,
    required int isikMin,
    required int isikMax,
    this.isPreset = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : bitkiAdi = Value(bitkiAdi),
        sicaklikMin = Value(sicaklikMin),
        sicaklikMax = Value(sicaklikMax),
        sicaklikStres = Value(sicaklikStres),
        nemMin = Value(nemMin),
        nemMax = Value(nemMax),
        toprakKuruEsik = Value(toprakKuruEsik),
        sulamaSureMax = Value(sulamaSureMax),
        isikMin = Value(isikMin),
        isikMax = Value(isikMax);
  static Insertable<PlantProfile> custom({
    Expression<int>? id,
    Expression<String>? bitkiAdi,
    Expression<String>? bitkiAdiTr,
    Expression<double>? sicaklikMin,
    Expression<double>? sicaklikMax,
    Expression<double>? sicaklikStres,
    Expression<double>? nemMin,
    Expression<double>? nemMax,
    Expression<double>? toprakKuruEsik,
    Expression<int>? sulamaSureMax,
    Expression<int>? isikMin,
    Expression<int>? isikMax,
    Expression<bool>? isPreset,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bitkiAdi != null) 'bitki_adi': bitkiAdi,
      if (bitkiAdiTr != null) 'bitki_adi_tr': bitkiAdiTr,
      if (sicaklikMin != null) 'sicaklik_min': sicaklikMin,
      if (sicaklikMax != null) 'sicaklik_max': sicaklikMax,
      if (sicaklikStres != null) 'sicaklik_stres': sicaklikStres,
      if (nemMin != null) 'nem_min': nemMin,
      if (nemMax != null) 'nem_max': nemMax,
      if (toprakKuruEsik != null) 'toprak_kuru_esik': toprakKuruEsik,
      if (sulamaSureMax != null) 'sulama_sure_max': sulamaSureMax,
      if (isikMin != null) 'isik_min': isikMin,
      if (isikMax != null) 'isik_max': isikMax,
      if (isPreset != null) 'is_preset': isPreset,
      if (isActive != null) 'is_active': isActive,
    });
  }

  PlantProfilesCompanion copyWith(
      {Value<int>? id,
      Value<String>? bitkiAdi,
      Value<String?>? bitkiAdiTr,
      Value<double>? sicaklikMin,
      Value<double>? sicaklikMax,
      Value<double>? sicaklikStres,
      Value<double>? nemMin,
      Value<double>? nemMax,
      Value<double>? toprakKuruEsik,
      Value<int>? sulamaSureMax,
      Value<int>? isikMin,
      Value<int>? isikMax,
      Value<bool>? isPreset,
      Value<bool>? isActive}) {
    return PlantProfilesCompanion(
      id: id ?? this.id,
      bitkiAdi: bitkiAdi ?? this.bitkiAdi,
      bitkiAdiTr: bitkiAdiTr ?? this.bitkiAdiTr,
      sicaklikMin: sicaklikMin ?? this.sicaklikMin,
      sicaklikMax: sicaklikMax ?? this.sicaklikMax,
      sicaklikStres: sicaklikStres ?? this.sicaklikStres,
      nemMin: nemMin ?? this.nemMin,
      nemMax: nemMax ?? this.nemMax,
      toprakKuruEsik: toprakKuruEsik ?? this.toprakKuruEsik,
      sulamaSureMax: sulamaSureMax ?? this.sulamaSureMax,
      isikMin: isikMin ?? this.isikMin,
      isikMax: isikMax ?? this.isikMax,
      isPreset: isPreset ?? this.isPreset,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bitkiAdi.present) {
      map['bitki_adi'] = Variable<String>(bitkiAdi.value);
    }
    if (bitkiAdiTr.present) {
      map['bitki_adi_tr'] = Variable<String>(bitkiAdiTr.value);
    }
    if (sicaklikMin.present) {
      map['sicaklik_min'] = Variable<double>(sicaklikMin.value);
    }
    if (sicaklikMax.present) {
      map['sicaklik_max'] = Variable<double>(sicaklikMax.value);
    }
    if (sicaklikStres.present) {
      map['sicaklik_stres'] = Variable<double>(sicaklikStres.value);
    }
    if (nemMin.present) {
      map['nem_min'] = Variable<double>(nemMin.value);
    }
    if (nemMax.present) {
      map['nem_max'] = Variable<double>(nemMax.value);
    }
    if (toprakKuruEsik.present) {
      map['toprak_kuru_esik'] = Variable<double>(toprakKuruEsik.value);
    }
    if (sulamaSureMax.present) {
      map['sulama_sure_max'] = Variable<int>(sulamaSureMax.value);
    }
    if (isikMin.present) {
      map['isik_min'] = Variable<int>(isikMin.value);
    }
    if (isikMax.present) {
      map['isik_max'] = Variable<int>(isikMax.value);
    }
    if (isPreset.present) {
      map['is_preset'] = Variable<bool>(isPreset.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantProfilesCompanion(')
          ..write('id: $id, ')
          ..write('bitkiAdi: $bitkiAdi, ')
          ..write('bitkiAdiTr: $bitkiAdiTr, ')
          ..write('sicaklikMin: $sicaklikMin, ')
          ..write('sicaklikMax: $sicaklikMax, ')
          ..write('sicaklikStres: $sicaklikStres, ')
          ..write('nemMin: $nemMin, ')
          ..write('nemMax: $nemMax, ')
          ..write('toprakKuruEsik: $toprakKuruEsik, ')
          ..write('sulamaSureMax: $sulamaSureMax, ')
          ..write('isikMin: $isikMin, ')
          ..write('isikMax: $isikMax, ')
          ..write('isPreset: $isPreset, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $SensorReadingsTable sensorReadings = $SensorReadingsTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $PlantProfilesTable plantProfiles = $PlantProfilesTable(this);
  late final Index idxReadingsDeviceTs = Index('idx_readings_device_ts',
      'CREATE INDEX idx_readings_device_ts ON sensor_readings (device_id, ts)');
  late final Index idxReadingsTs = Index('idx_readings_ts',
      'CREATE INDEX idx_readings_ts ON sensor_readings (ts)');
  late final Index idxEventsDeviceTs = Index('idx_events_device_ts',
      'CREATE INDEX idx_events_device_ts ON events (device_id, ts)');
  late final Index idxEventsTs =
      Index('idx_events_ts', 'CREATE INDEX idx_events_ts ON events (ts)');
  late final Index idxEventsKind =
      Index('idx_events_kind', 'CREATE INDEX idx_events_kind ON events (kind)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        devices,
        sensorReadings,
        events,
        plantProfiles,
        idxReadingsDeviceTs,
        idxReadingsTs,
        idxEventsDeviceTs,
        idxEventsTs,
        idxEventsKind
      ];
}

typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> mac,
  Value<String?> token,
  Value<int?> lastSeenAt,
  Value<bool> isActive,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> mac,
  Value<String?> token,
  Value<int?> lastSeenAt,
  Value<bool> isActive,
});

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, Device> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SensorReadingsTable, List<SensorReading>>
      _sensorReadingsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sensorReadings,
              aliasName: $_aliasNameGenerator(
                  db.devices.id, db.sensorReadings.deviceId));

  $$SensorReadingsTableProcessedTableManager get sensorReadingsRefs {
    final manager = $$SensorReadingsTableTableManager($_db, $_db.sensorReadings)
        .filter((f) => f.deviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sensorReadingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.events,
          aliasName: $_aliasNameGenerator(db.devices.id, db.events.deviceId));

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager($_db, $_db.events)
        .filter((f) => f.deviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> sensorReadingsRefs(
      Expression<bool> Function($$SensorReadingsTableFilterComposer f) f) {
    final $$SensorReadingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sensorReadings,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SensorReadingsTableFilterComposer(
              $db: $db,
              $table: $db.sensorReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> eventsRefs(
      Expression<bool> Function($$EventsTableFilterComposer f) f) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableFilterComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mac => $composableBuilder(
      column: $table.mac, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mac =>
      $composableBuilder(column: $table.mac, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<int> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> sensorReadingsRefs<T extends Object>(
      Expression<T> Function($$SensorReadingsTableAnnotationComposer a) f) {
    final $$SensorReadingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sensorReadings,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SensorReadingsTableAnnotationComposer(
              $db: $db,
              $table: $db.sensorReadings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> eventsRefs<T extends Object>(
      Expression<T> Function($$EventsTableAnnotationComposer a) f) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.events,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EventsTableAnnotationComposer(
              $db: $db,
              $table: $db.events,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DevicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, $$DevicesTableReferences),
    Device,
    PrefetchHooks Function({bool sensorReadingsRefs, bool eventsRefs})> {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> mac = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<int?> lastSeenAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              DevicesCompanion(
            id: id,
            name: name,
            mac: mac,
            token: token,
            lastSeenAt: lastSeenAt,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> mac = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<int?> lastSeenAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              DevicesCompanion.insert(
            id: id,
            name: name,
            mac: mac,
            token: token,
            lastSeenAt: lastSeenAt,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DevicesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {sensorReadingsRefs = false, eventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sensorReadingsRefs) db.sensorReadings,
                if (eventsRefs) db.events
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sensorReadingsRefs)
                    await $_getPrefetchedData<Device, $DevicesTable,
                            SensorReading>(
                        currentTable: table,
                        referencedTable: $$DevicesTableReferences
                            ._sensorReadingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DevicesTableReferences(db, table, p0)
                                .sensorReadingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.deviceId == item.id),
                        typedResults: items),
                  if (eventsRefs)
                    await $_getPrefetchedData<Device, $DevicesTable, Event>(
                        currentTable: table,
                        referencedTable:
                            $$DevicesTableReferences._eventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DevicesTableReferences(db, table, p0).eventsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.deviceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DevicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, $$DevicesTableReferences),
    Device,
    PrefetchHooks Function({bool sensorReadingsRefs, bool eventsRefs})>;
typedef $$SensorReadingsTableCreateCompanionBuilder = SensorReadingsCompanion
    Function({
  Value<int> id,
  required int deviceId,
  required int ts,
  Value<double?> temperatureC,
  Value<double?> humidityPct,
  Value<int?> soilMoisture,
  Value<int?> lightLux,
  Value<bool> pumpActive,
  Value<String?> bitkiAdi,
});
typedef $$SensorReadingsTableUpdateCompanionBuilder = SensorReadingsCompanion
    Function({
  Value<int> id,
  Value<int> deviceId,
  Value<int> ts,
  Value<double?> temperatureC,
  Value<double?> humidityPct,
  Value<int?> soilMoisture,
  Value<int?> lightLux,
  Value<bool> pumpActive,
  Value<String?> bitkiAdi,
});

final class $$SensorReadingsTableReferences
    extends BaseReferences<_$AppDatabase, $SensorReadingsTable, SensorReading> {
  $$SensorReadingsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias(
          $_aliasNameGenerator(db.sensorReadings.deviceId, db.devices.id));

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<int>('device_id')!;

    final manager = $$DevicesTableTableManager($_db, $_db.devices)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SensorReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $SensorReadingsTable> {
  $$SensorReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get temperatureC => $composableBuilder(
      column: $table.temperatureC, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get humidityPct => $composableBuilder(
      column: $table.humidityPct, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get soilMoisture => $composableBuilder(
      column: $table.soilMoisture, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lightLux => $composableBuilder(
      column: $table.lightLux, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pumpActive => $composableBuilder(
      column: $table.pumpActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bitkiAdi => $composableBuilder(
      column: $table.bitkiAdi, builder: (column) => ColumnFilters(column));

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableFilterComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SensorReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SensorReadingsTable> {
  $$SensorReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get temperatureC => $composableBuilder(
      column: $table.temperatureC,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get humidityPct => $composableBuilder(
      column: $table.humidityPct, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get soilMoisture => $composableBuilder(
      column: $table.soilMoisture,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lightLux => $composableBuilder(
      column: $table.lightLux, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pumpActive => $composableBuilder(
      column: $table.pumpActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bitkiAdi => $composableBuilder(
      column: $table.bitkiAdi, builder: (column) => ColumnOrderings(column));

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableOrderingComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SensorReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SensorReadingsTable> {
  $$SensorReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<double> get temperatureC => $composableBuilder(
      column: $table.temperatureC, builder: (column) => column);

  GeneratedColumn<double> get humidityPct => $composableBuilder(
      column: $table.humidityPct, builder: (column) => column);

  GeneratedColumn<int> get soilMoisture => $composableBuilder(
      column: $table.soilMoisture, builder: (column) => column);

  GeneratedColumn<int> get lightLux =>
      $composableBuilder(column: $table.lightLux, builder: (column) => column);

  GeneratedColumn<bool> get pumpActive => $composableBuilder(
      column: $table.pumpActive, builder: (column) => column);

  GeneratedColumn<String> get bitkiAdi =>
      $composableBuilder(column: $table.bitkiAdi, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableAnnotationComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SensorReadingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SensorReadingsTable,
    SensorReading,
    $$SensorReadingsTableFilterComposer,
    $$SensorReadingsTableOrderingComposer,
    $$SensorReadingsTableAnnotationComposer,
    $$SensorReadingsTableCreateCompanionBuilder,
    $$SensorReadingsTableUpdateCompanionBuilder,
    (SensorReading, $$SensorReadingsTableReferences),
    SensorReading,
    PrefetchHooks Function({bool deviceId})> {
  $$SensorReadingsTableTableManager(
      _$AppDatabase db, $SensorReadingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SensorReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SensorReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SensorReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> deviceId = const Value.absent(),
            Value<int> ts = const Value.absent(),
            Value<double?> temperatureC = const Value.absent(),
            Value<double?> humidityPct = const Value.absent(),
            Value<int?> soilMoisture = const Value.absent(),
            Value<int?> lightLux = const Value.absent(),
            Value<bool> pumpActive = const Value.absent(),
            Value<String?> bitkiAdi = const Value.absent(),
          }) =>
              SensorReadingsCompanion(
            id: id,
            deviceId: deviceId,
            ts: ts,
            temperatureC: temperatureC,
            humidityPct: humidityPct,
            soilMoisture: soilMoisture,
            lightLux: lightLux,
            pumpActive: pumpActive,
            bitkiAdi: bitkiAdi,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int deviceId,
            required int ts,
            Value<double?> temperatureC = const Value.absent(),
            Value<double?> humidityPct = const Value.absent(),
            Value<int?> soilMoisture = const Value.absent(),
            Value<int?> lightLux = const Value.absent(),
            Value<bool> pumpActive = const Value.absent(),
            Value<String?> bitkiAdi = const Value.absent(),
          }) =>
              SensorReadingsCompanion.insert(
            id: id,
            deviceId: deviceId,
            ts: ts,
            temperatureC: temperatureC,
            humidityPct: humidityPct,
            soilMoisture: soilMoisture,
            lightLux: lightLux,
            pumpActive: pumpActive,
            bitkiAdi: bitkiAdi,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SensorReadingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (deviceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deviceId,
                    referencedTable:
                        $$SensorReadingsTableReferences._deviceIdTable(db),
                    referencedColumn:
                        $$SensorReadingsTableReferences._deviceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SensorReadingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SensorReadingsTable,
    SensorReading,
    $$SensorReadingsTableFilterComposer,
    $$SensorReadingsTableOrderingComposer,
    $$SensorReadingsTableAnnotationComposer,
    $$SensorReadingsTableCreateCompanionBuilder,
    $$SensorReadingsTableUpdateCompanionBuilder,
    (SensorReading, $$SensorReadingsTableReferences),
    SensorReading,
    PrefetchHooks Function({bool deviceId})>;
typedef $$EventsTableCreateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  required int deviceId,
  required int ts,
  required String kind,
  Value<String?> payload,
});
typedef $$EventsTableUpdateCompanionBuilder = EventsCompanion Function({
  Value<int> id,
  Value<int> deviceId,
  Value<int> ts,
  Value<String> kind,
  Value<String?> payload,
});

final class $$EventsTableReferences
    extends BaseReferences<_$AppDatabase, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DevicesTable _deviceIdTable(_$AppDatabase db) => db.devices
      .createAlias($_aliasNameGenerator(db.events.deviceId, db.devices.id));

  $$DevicesTableProcessedTableManager get deviceId {
    final $_column = $_itemColumn<int>('device_id')!;

    final manager = $$DevicesTableTableManager($_db, $_db.devices)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EventsTableFilterComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableFilterComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ts => $composableBuilder(
      column: $table.ts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableOrderingComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableAnnotationComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool deviceId})> {
  $$EventsTableTableManager(_$AppDatabase db, $EventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> deviceId = const Value.absent(),
            Value<int> ts = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String?> payload = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            deviceId: deviceId,
            ts: ts,
            kind: kind,
            payload: payload,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int deviceId,
            required int ts,
            required String kind,
            Value<String?> payload = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            deviceId: deviceId,
            ts: ts,
            kind: kind,
            payload: payload,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EventsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (deviceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deviceId,
                    referencedTable: $$EventsTableReferences._deviceIdTable(db),
                    referencedColumn:
                        $$EventsTableReferences._deviceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EventsTable,
    Event,
    $$EventsTableFilterComposer,
    $$EventsTableOrderingComposer,
    $$EventsTableAnnotationComposer,
    $$EventsTableCreateCompanionBuilder,
    $$EventsTableUpdateCompanionBuilder,
    (Event, $$EventsTableReferences),
    Event,
    PrefetchHooks Function({bool deviceId})>;
typedef $$PlantProfilesTableCreateCompanionBuilder = PlantProfilesCompanion
    Function({
  Value<int> id,
  required String bitkiAdi,
  Value<String?> bitkiAdiTr,
  required double sicaklikMin,
  required double sicaklikMax,
  required double sicaklikStres,
  required double nemMin,
  required double nemMax,
  required double toprakKuruEsik,
  required int sulamaSureMax,
  required int isikMin,
  required int isikMax,
  Value<bool> isPreset,
  Value<bool> isActive,
});
typedef $$PlantProfilesTableUpdateCompanionBuilder = PlantProfilesCompanion
    Function({
  Value<int> id,
  Value<String> bitkiAdi,
  Value<String?> bitkiAdiTr,
  Value<double> sicaklikMin,
  Value<double> sicaklikMax,
  Value<double> sicaklikStres,
  Value<double> nemMin,
  Value<double> nemMax,
  Value<double> toprakKuruEsik,
  Value<int> sulamaSureMax,
  Value<int> isikMin,
  Value<int> isikMax,
  Value<bool> isPreset,
  Value<bool> isActive,
});

class $$PlantProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PlantProfilesTable> {
  $$PlantProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bitkiAdi => $composableBuilder(
      column: $table.bitkiAdi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bitkiAdiTr => $composableBuilder(
      column: $table.bitkiAdiTr, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sicaklikMin => $composableBuilder(
      column: $table.sicaklikMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sicaklikMax => $composableBuilder(
      column: $table.sicaklikMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sicaklikStres => $composableBuilder(
      column: $table.sicaklikStres, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nemMin => $composableBuilder(
      column: $table.nemMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get nemMax => $composableBuilder(
      column: $table.nemMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get toprakKuruEsik => $composableBuilder(
      column: $table.toprakKuruEsik,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sulamaSureMax => $composableBuilder(
      column: $table.sulamaSureMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isikMin => $composableBuilder(
      column: $table.isikMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isikMax => $composableBuilder(
      column: $table.isikMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPreset => $composableBuilder(
      column: $table.isPreset, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$PlantProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlantProfilesTable> {
  $$PlantProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bitkiAdi => $composableBuilder(
      column: $table.bitkiAdi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bitkiAdiTr => $composableBuilder(
      column: $table.bitkiAdiTr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sicaklikMin => $composableBuilder(
      column: $table.sicaklikMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sicaklikMax => $composableBuilder(
      column: $table.sicaklikMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sicaklikStres => $composableBuilder(
      column: $table.sicaklikStres,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nemMin => $composableBuilder(
      column: $table.nemMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get nemMax => $composableBuilder(
      column: $table.nemMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get toprakKuruEsik => $composableBuilder(
      column: $table.toprakKuruEsik,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sulamaSureMax => $composableBuilder(
      column: $table.sulamaSureMax,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isikMin => $composableBuilder(
      column: $table.isikMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isikMax => $composableBuilder(
      column: $table.isikMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPreset => $composableBuilder(
      column: $table.isPreset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$PlantProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlantProfilesTable> {
  $$PlantProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bitkiAdi =>
      $composableBuilder(column: $table.bitkiAdi, builder: (column) => column);

  GeneratedColumn<String> get bitkiAdiTr => $composableBuilder(
      column: $table.bitkiAdiTr, builder: (column) => column);

  GeneratedColumn<double> get sicaklikMin => $composableBuilder(
      column: $table.sicaklikMin, builder: (column) => column);

  GeneratedColumn<double> get sicaklikMax => $composableBuilder(
      column: $table.sicaklikMax, builder: (column) => column);

  GeneratedColumn<double> get sicaklikStres => $composableBuilder(
      column: $table.sicaklikStres, builder: (column) => column);

  GeneratedColumn<double> get nemMin =>
      $composableBuilder(column: $table.nemMin, builder: (column) => column);

  GeneratedColumn<double> get nemMax =>
      $composableBuilder(column: $table.nemMax, builder: (column) => column);

  GeneratedColumn<double> get toprakKuruEsik => $composableBuilder(
      column: $table.toprakKuruEsik, builder: (column) => column);

  GeneratedColumn<int> get sulamaSureMax => $composableBuilder(
      column: $table.sulamaSureMax, builder: (column) => column);

  GeneratedColumn<int> get isikMin =>
      $composableBuilder(column: $table.isikMin, builder: (column) => column);

  GeneratedColumn<int> get isikMax =>
      $composableBuilder(column: $table.isikMax, builder: (column) => column);

  GeneratedColumn<bool> get isPreset =>
      $composableBuilder(column: $table.isPreset, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$PlantProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlantProfilesTable,
    PlantProfile,
    $$PlantProfilesTableFilterComposer,
    $$PlantProfilesTableOrderingComposer,
    $$PlantProfilesTableAnnotationComposer,
    $$PlantProfilesTableCreateCompanionBuilder,
    $$PlantProfilesTableUpdateCompanionBuilder,
    (
      PlantProfile,
      BaseReferences<_$AppDatabase, $PlantProfilesTable, PlantProfile>
    ),
    PlantProfile,
    PrefetchHooks Function()> {
  $$PlantProfilesTableTableManager(_$AppDatabase db, $PlantProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlantProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlantProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlantProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bitkiAdi = const Value.absent(),
            Value<String?> bitkiAdiTr = const Value.absent(),
            Value<double> sicaklikMin = const Value.absent(),
            Value<double> sicaklikMax = const Value.absent(),
            Value<double> sicaklikStres = const Value.absent(),
            Value<double> nemMin = const Value.absent(),
            Value<double> nemMax = const Value.absent(),
            Value<double> toprakKuruEsik = const Value.absent(),
            Value<int> sulamaSureMax = const Value.absent(),
            Value<int> isikMin = const Value.absent(),
            Value<int> isikMax = const Value.absent(),
            Value<bool> isPreset = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              PlantProfilesCompanion(
            id: id,
            bitkiAdi: bitkiAdi,
            bitkiAdiTr: bitkiAdiTr,
            sicaklikMin: sicaklikMin,
            sicaklikMax: sicaklikMax,
            sicaklikStres: sicaklikStres,
            nemMin: nemMin,
            nemMax: nemMax,
            toprakKuruEsik: toprakKuruEsik,
            sulamaSureMax: sulamaSureMax,
            isikMin: isikMin,
            isikMax: isikMax,
            isPreset: isPreset,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bitkiAdi,
            Value<String?> bitkiAdiTr = const Value.absent(),
            required double sicaklikMin,
            required double sicaklikMax,
            required double sicaklikStres,
            required double nemMin,
            required double nemMax,
            required double toprakKuruEsik,
            required int sulamaSureMax,
            required int isikMin,
            required int isikMax,
            Value<bool> isPreset = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              PlantProfilesCompanion.insert(
            id: id,
            bitkiAdi: bitkiAdi,
            bitkiAdiTr: bitkiAdiTr,
            sicaklikMin: sicaklikMin,
            sicaklikMax: sicaklikMax,
            sicaklikStres: sicaklikStres,
            nemMin: nemMin,
            nemMax: nemMax,
            toprakKuruEsik: toprakKuruEsik,
            sulamaSureMax: sulamaSureMax,
            isikMin: isikMin,
            isikMax: isikMax,
            isPreset: isPreset,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlantProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlantProfilesTable,
    PlantProfile,
    $$PlantProfilesTableFilterComposer,
    $$PlantProfilesTableOrderingComposer,
    $$PlantProfilesTableAnnotationComposer,
    $$PlantProfilesTableCreateCompanionBuilder,
    $$PlantProfilesTableUpdateCompanionBuilder,
    (
      PlantProfile,
      BaseReferences<_$AppDatabase, $PlantProfilesTable, PlantProfile>
    ),
    PlantProfile,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$SensorReadingsTableTableManager get sensorReadings =>
      $$SensorReadingsTableTableManager(_db, _db.sensorReadings);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$PlantProfilesTableTableManager get plantProfiles =>
      $$PlantProfilesTableTableManager(_db, _db.plantProfiles);
}

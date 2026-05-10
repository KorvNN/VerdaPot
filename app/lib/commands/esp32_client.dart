import 'package:dio/dio.dart';

import '../data/database.dart';
import '../server/auth_middleware.dart' show kDeviceTokenHeader;

/// ESP32'nin komutu kabul etmediği veya cihaza ulaşamadığı durumlar için.
class Esp32CommandException implements Exception {
  Esp32CommandException(this.message, {this.statusCode, this.reason});
  final String message;
  final int? statusCode;
  final String? reason;   // örn: "soil_ok" (manuel sulama reddi)

  @override
  String toString() => statusCode == null
      ? 'Esp32CommandException: $message'
      : 'Esp32CommandException($statusCode): $message';
}

/// App → ESP32 komut istemcisi.
///
/// İki uzak ucu vardır:
///   • POST /cmd/set_profile — aktif bitkinin tüm fuzzy parametreleri
///   • POST /cmd/manual_pump — toprak kontrolüyle manuel sulama isteği
///
/// Her istek 5 saniyelik bir bütçeye sahiptir. Geçici transport hataları ve
/// 5xx yanıtları bir kez tekrar denenir; 4xx ve 409 (pump_busy) anında
/// yukarıya yansıtılır.
class Esp32Client {
  Esp32Client({
    required this.baseUrl,
    required this.token,
    Dio? dio,
  }) : _dio = dio ?? _defaultDio(baseUrl);

  final String baseUrl;
  final String token;
  final Dio _dio;

  static Dio _defaultDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );
  }

  /// Aktif bitki profilini cihaza gönderir. Alanlar firmware'in beklediği
  /// JSON şemasıyla bire bir eşleşir.
  Future<void> setProfile(PlantProfile p) async {
    await _post('/cmd/set_profile', {
      'bitki_adi':         p.bitkiAdi,
      'sicaklik_min':      p.sicaklikMin,
      'sicaklik_max':      p.sicaklikMax,
      'sicaklik_stres':    p.sicaklikStres,
      'nem_min':           p.nemMin,
      'nem_max':           p.nemMax,
      'toprak_kuru_esik':  p.toprakKuruEsik,
      'sulama_sure_max':   p.sulamaSureMax,
      'isik_min':          p.isikMin,
      'isik_max':          p.isikMax,
    });
  }

  /// Manuel sulama tetikler. Cihaz anlık toprak nemini ölçer ve karar verir:
  ///   • Toprak eşik altındaysa fuzzy ile süre hesaplanıp pompa çalıştırılır.
  ///   • Toprak yeterince ıslaksa istek "soil_ok" gerekçesiyle reddedilir.
  ///   • Pompa zaten çalışıyorsa "pump_busy" gerekçesiyle reddedilir.
  Future<ManualPumpResult> manualPump() async {
    try {
      final res = await _withRetry(() => _dio.post<dynamic>(
            '/cmd/manual_pump',
            data: const <String, Object?>{},
            options: Options(headers: {kDeviceTokenHeader: token}),
          ));
      final data = res.data;
      if (data is Map && data['status'] == 'rejected') {
        return ManualPumpResult.rejected(reason: data['reason']?.toString() ?? 'unknown');
      }
      return ManualPumpResult.accepted();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 409) {
        return ManualPumpResult.rejected(reason: 'pump_busy');
      }
      throw Esp32CommandException(
        e.message ?? e.type.name,
        statusCode: code,
      );
    }
  }

  Future<void> _post(String path, Map<String, Object?> body) async {
    try {
      await _withRetry(() => _dio.post<dynamic>(
            path,
            data: body,
            options: Options(headers: {kDeviceTokenHeader: token}),
          ));
    } on DioException catch (e) {
      throw Esp32CommandException(
        e.message ?? e.type.name,
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response<T>> _withRetry<T>(
    Future<Response<T>> Function() send,
  ) async {
    try {
      return await send();
    } on DioException catch (e) {
      if (!_shouldRetry(e)) rethrow;
      return await send();
    }
  }

  static bool _shouldRetry(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        return code >= 500 && code < 600;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
}

class ManualPumpResult {
  ManualPumpResult._(this.accepted, this.reason);
  factory ManualPumpResult.accepted()             => ManualPumpResult._(true, null);
  factory ManualPumpResult.rejected({required String reason})
                                                  => ManualPumpResult._(false, reason);
  final bool    accepted;
  final String? reason;   // "soil_ok" | "pump_busy" | ...
}

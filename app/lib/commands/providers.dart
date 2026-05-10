import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dashboard/providers.dart' show activeDeviceProvider;
import '../settings/providers.dart';
import 'esp32_client.dart';

/// Tracks the active device + configured ESP32 base URL so the client is
/// rebuilt whenever either changes. Returns `null` until both are set.
final esp32ClientProvider = Provider<Esp32Client?>((ref) {
  final baseUrl = ref.watch(esp32BaseUrlProvider);
  if (baseUrl == null) return null;

  final token = ref.watch(activeDeviceProvider).asData?.value?.token;
  if (token == null || token.isEmpty) return null;

  return Esp32Client(baseUrl: baseUrl, token: token);
});

import 'package:shelf/shelf.dart';

typedef TokenLookup = Future<String?> Function();

const String kDeviceTokenHeader = 'x-device-token';

/// Validates [kDeviceTokenHeader] against the value returned by [expected].
/// Returns 401 on mismatch, 503 if the server hasn't paired yet (no token set).
/// Bypasses paths in [skipPaths] (default: `/health` — useful for sanity probes).
///
/// shelf passes paths to handlers without a leading slash, so [skipPaths] entries
/// are matched against the URL path with leading slash stripped.
Middleware tokenAuthMiddleware({
  required TokenLookup expected,
  Set<String> skipPaths = const {'/health'},
}) {
  final skip = skipPaths.map((p) => p.startsWith('/') ? p.substring(1) : p).toSet();

  return (Handler innerHandler) {
    return (Request request) async {
      if (skip.contains(request.url.path)) {
        return innerHandler(request);
      }

      final expectedToken = await expected();
      if (expectedToken == null || expectedToken.isEmpty) {
        return Response(503, body: 'server not paired yet — no device token set');
      }

      final providedToken = request.headers[kDeviceTokenHeader];
      if (providedToken == null || providedToken != expectedToken) {
        return Response(401, body: 'invalid or missing $kDeviceTokenHeader');
      }

      return innerHandler(request);
    };
  };
}

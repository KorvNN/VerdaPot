import 'package:bonsoir/bonsoir.dart';

/// Advertises the embedded HTTP server via mDNS so the ESP32 can discover
/// it without a hard-coded IP. Service type is `_smartplant._tcp`.
class MdnsBroadcaster {
  MdnsBroadcaster({this.serviceName = 'SmartPlant'});

  final String serviceName;
  BonsoirBroadcast? _broadcast;

  bool get isRunning => _broadcast != null;

  Future<void> start({required int port}) async {
    if (_broadcast != null) return;
    final service = BonsoirService(
      name: serviceName,
      type: '_smartplant._tcp',
      port: port,
    );
    final broadcast = BonsoirBroadcast(service: service);
    await broadcast.start();
    _broadcast = broadcast;
  }

  Future<void> stop() async {
    final b = _broadcast;
    _broadcast = null;
    if (b != null) {
      try {
        await b.stop();
      } catch (_) {
        // best-effort: bonsoir may throw if already torn down
      }
    }
  }
}

import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over SharedPreferences for app-level settings.
/// Per-device data (notably the auth token) lives in the `devices` table, not here.
class SettingsRepo {
  SettingsRepo(this._prefs);
  final SharedPreferences _prefs;

  static const String _kPort = 'app_server_port';
  static const String _kEsp32BaseUrl = 'esp32_base_url';
  static const int defaultPort = 8080;

  int get serverPort => _prefs.getInt(_kPort) ?? defaultPort;
  Future<bool> setServerPort(int port) => _prefs.setInt(_kPort, port);

  String? get esp32BaseUrl => _prefs.getString(_kEsp32BaseUrl);
  Future<bool> setEsp32BaseUrl(String url) =>
      _prefs.setString(_kEsp32BaseUrl, url);
}

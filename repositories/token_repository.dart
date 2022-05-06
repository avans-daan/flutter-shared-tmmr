import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository {
  //region Singleton
  factory TokenRepository() {
    if (_instance == null) {
      throw Exception('Token repository not yet initialised');
    }
    return _instance as TokenRepository;
  }

  TokenRepository._internal();

  static TokenRepository? _instance;

  //endregion

  static const tokenKey = 'AUTH_BEARER_TOKEN';
  static const tokenExpiresKey = 'AUTH_BEARER_EXPIRES_AT';
  String? _token;
  DateTime? _expiresAt;

  static Future<bool> init() async {
    if (_instance != null) return true;
    _instance = TokenRepository._internal();
    var prefs = await SharedPreferences.getInstance();
    _instance?._token = prefs.getString(tokenKey);
    var expiresAtString = prefs.getString(tokenExpiresKey);
    _instance?._expiresAt =
        expiresAtString != null ? DateTime.parse(expiresAtString) : null;
    return true;
  }

  String? getToken() {
    return _token;
  }

  DateTime? getExpiresAt() {
    return _expiresAt;
  }

  Future<void> setToken(String token) async {
    _token = token;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> setExpiresAt(String expiresAtString) async {
    var expiresAt = DateTime.parse(expiresAtString);
    _expiresAt = expiresAt;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenExpiresKey, expiresAtString);
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenExpiresKey);
    await prefs.remove(tokenKey);
    _token = null;
    _expiresAt = null;
  }
}

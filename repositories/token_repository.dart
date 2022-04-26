import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository {
  static const tokenKey = "AUTH_BEARER_TOKEN";
  static const tokenExpiresKey = "AUTH_BEARER_EXPIRES_AT";

  //region Singleton
  TokenRepository._internal();

  static TokenRepository? _instance;

  factory TokenRepository() {
    if (_instance == null) throw "Token repository not yet initialised";
    return _instance as TokenRepository;
  }

  //endregion

  String? _token;
  DateTime? _expiresAt;

  static Future init() async {
    if (_instance != null) return;
    _instance = TokenRepository._internal();
    var prefs = await SharedPreferences.getInstance();
    _instance?._token = prefs.getString(tokenKey);
    var expiresAtString = prefs.getString(tokenExpiresKey);
    _instance?._expiresAt =
        expiresAtString != null ? DateTime.parse(expiresAtString) : null;
  }

  String? getToken() {
    return _token;
  }

  DateTime? getExpiresAt() {
    return _expiresAt;
  }

  Future setToken(String token) async {
    _token = token;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future setExpiresAt(String expiresAtString) async {
    var expiresAt = DateTime.parse(expiresAtString);
    _expiresAt = expiresAt;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenExpiresKey, expiresAtString);
  }
}

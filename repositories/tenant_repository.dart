import 'package:shared_preferences/shared_preferences.dart';

class TenantRepository {
  //region Singleton

  factory TenantRepository() {
    if (_instance == null) {
      throw Exception('Tenant repository not yet initialised');
    }
    return _instance as TenantRepository;
  }

  TenantRepository._internal();

  static TenantRepository? _instance;

  //endregion

  static const tenantKey = 'CURRENT_TENANT_ID';
  String? _tenantId;

  static Future<bool> init() async {
    if (_instance != null) return true;
    _instance = TenantRepository._internal();
    var prefs = await SharedPreferences.getInstance();
    _instance?._tenantId = prefs.getString(tenantKey);
    return true;
  }

  String? getTenantId() {
    return _tenantId;
  }

  Future<void> setTenantId(String tenantId) async {
    _tenantId = tenantId;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tenantKey, tenantId);
  }
}

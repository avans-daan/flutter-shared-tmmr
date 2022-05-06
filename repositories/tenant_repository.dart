import 'package:shared_preferences/shared_preferences.dart';

class TenantRepository {
  static const tenantKey = 'CURRENT_TENANT_ID';

  //region Singleton
  TenantRepository._internal();

  static TenantRepository? _instance;

  factory TenantRepository() {
    if (_instance == null) throw 'Tenant repository not yet initialised';
    return _instance as TenantRepository;
  }

  //endregion

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

  Future setTenantId(String tenantId) async {
    _tenantId = tenantId;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(tenantKey, tenantId);
  }
}

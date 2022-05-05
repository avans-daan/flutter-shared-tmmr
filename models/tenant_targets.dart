import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api-resources/target.dart';
import '../http_client.dart';
import 'user_tenants.dart';

class TenantTargets {
  static final provider = FutureProvider<List<Target>>((ref) async {
    var selectedTenant = ref.watch(UserSelectedTenantNotifier.provider);
    if (selectedTenant.id.isEmpty) {
      return List.empty();
    }

    final response = await HttpClient()
        .getAuthorizedClient()
        .get("/api/tenants/${selectedTenant.id}/targets");
    final dataArray = response.data['data'] as List;
    return dataArray.map((e) => Target.fromJson(e)).toList();
  });
}

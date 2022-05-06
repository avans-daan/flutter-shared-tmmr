import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api-resources/time_entry.dart';
import '../http_client.dart';
import 'user_tenants.dart';

class UserTimer {
  static final provider = FutureProvider<TimeEntry?>((ref) async {
    var selectedTenant = ref.watch(UserSelectedTenantNotifier.provider);
    if (selectedTenant.id.isEmpty) {
      // When current tenant isn't know yet the id will be empty
      return null;
    }

    try {
      final response = await HttpClient()
          .getAuthorizedClient()
          .get("/api/tenants/${selectedTenant.id}/timer");
      return TimeEntry.fromJson(response.data['data']);
    } catch (err) {
      // TODO Error handling user story?
      return null;
    }
  });
}

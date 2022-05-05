import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api-resources/tenant.dart';
import '../http_client.dart';

@immutable
class UserTenants {
  final List<Tenant> tenants;
  final Tenant selectedTenant;

  const UserTenants({required this.tenants, required this.selectedTenant});

  UserTenants copyWith({
    List<Tenant>? tenants,
    Tenant? selectedTenant,
  }) {
    return UserTenants(
        tenants: tenants ?? this.tenants,
        selectedTenant: selectedTenant ?? this.selectedTenant);
  }
}

class UsersTenantsNotifier {
  static final provider = FutureProvider<List<Tenant>>((ref) async {
    final response =
        await HttpClient().getAuthorizedClient().get("/api/user/tenants");

    final dataArray = response.data['data'] as List;
    return dataArray.map((e) => Tenant.fromJson(e)).toList();
  });
}

class UserTenantsStateNotifier extends StateNotifier<UserTenants> {
  UserTenantsStateNotifier(UserTenants state) : super(state);

  static final provider =
      StateNotifierProvider<UserTenantsStateNotifier, UserTenants>((ref) {
    AsyncValue<List<Tenant>> tenants = ref.watch(UsersTenantsNotifier.provider);

    return tenants.when(
        loading: () => UserTenantsStateNotifier(UserTenants(
            tenants: List.empty(),
            selectedTenant: Tenant(id: "unknown", name: "Loading"))),
        error: (err, stack) => UserTenantsStateNotifier(UserTenants(
            tenants: List.empty(),
            selectedTenant: Tenant(id: "unknown", name: "Failed"))),
        data: (tenants) {
          return UserTenantsStateNotifier(UserTenants(
              tenants: tenants,
              selectedTenant:
                  tenants[0])); // TODO select tenant from stored preferences
        });
  });

  Future setActiveTenant({required Tenant tenant}) async {
    state = state.copyWith(selectedTenant: tenant);
  }
}

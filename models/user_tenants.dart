import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api-resources/tenant.dart';
import '../http_client.dart';
import '../repositories/tenant_repository.dart';

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
            selectedTenant: Tenant(id: "", name: "Loading"))),
        error: (err, stack) => UserTenantsStateNotifier(UserTenants(
            tenants: List.empty(),
            selectedTenant: Tenant(id: "", name: "Failed"))),
        data: (tenants) {
          if (tenants.isEmpty) {
            return UserTenantsStateNotifier(UserTenants(
                tenants: List.empty(),
                selectedTenant: Tenant(id: "", name: "No Tenants")));
          }

          // Auto select saved tenant or first from the list if none was set
          var tenantId = TenantRepository().getTenantId();
          var selectedTenant = tenants.firstWhere(
              (element) => element.id == tenantId,
              orElse: () => tenants[0]);

          return UserTenantsStateNotifier(
              UserTenants(tenants: tenants, selectedTenant: selectedTenant));
        });
  });

  Future setActiveTenant({required Tenant tenant}) async {
    state = state.copyWith(selectedTenant: tenant);
    await TenantRepository().setTenantId(tenant.id);
  }
}

class UserSelectedTenantNotifier {
  static final provider = Provider<Tenant>((ref) {
    return ref.watch(UserTenantsStateNotifier.provider
        .select((value) => value.selectedTenant));
  });
}

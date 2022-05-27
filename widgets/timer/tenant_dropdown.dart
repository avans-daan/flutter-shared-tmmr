import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared-tmmr/models/api-resources/tenant.dart';
import '../../../shared-tmmr/models/user_tenants.dart';

class TenantDropdown extends ConsumerWidget {
  const TenantDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tenants = ref.watch(UsersTenantsNotifier.provider);
    Tenant? selectedTenant = ref.watch(UserSelectedTenantNotifier.provider);

    return tenants.when(
        data: (tenants) {
          if (!tenants.contains(selectedTenant)) selectedTenant = null;
          return DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              value: selectedTenant,
              items: tenants
                  .map<DropdownMenuItem<Tenant>>((Tenant tenant) =>
                      DropdownMenuItem<Tenant>(
                          value: tenant,
                          child: Text(tenant.name,
                              style: Theme.of(context).textTheme.bodyMedium)))
                  .toList(),
              onChanged: (Tenant? s) {
                if (s == null) return;
                ref
                    .read(UserTenantsStateNotifier.provider.notifier)
                    .setActiveTenant(tenant: s);
              });
        },
        error: (err, stack) => const CircularProgressIndicator(),
        loading: () => const CircularProgressIndicator());
  }
}

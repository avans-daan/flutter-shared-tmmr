import 'package:flutter/cupertino.dart';

import '../api-resources/tenant.dart';

@immutable
class UserTenants {
  final List<Tenant> tenants;

  const UserTenants({
    required this.tenants,
  });

  UserTenants copyWith({
    List<Tenant>? tenants,
  }) {
    return UserTenants(
      tenants: tenants ?? this.tenants,
    );
  }
}


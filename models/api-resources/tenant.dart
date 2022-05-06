class Tenant {
  final String id;
  final String name;

  Tenant({required this.id, required this.name});

  static Tenant fromJson(dynamic content) {
    return Tenant(id: content['id'], name: content['name']);
  }
}

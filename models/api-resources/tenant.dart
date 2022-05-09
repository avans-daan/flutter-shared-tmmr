class Tenant {
  Tenant({required this.id, required this.name});

  final String id;
  final String name;

  static Tenant fromJson(dynamic content) {
    return Tenant(id: content['id'], name: content['name']);
  }
}

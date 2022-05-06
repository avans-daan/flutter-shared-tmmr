class Target {
  Target({required this.id, required this.name, required this.targetId});

  final String id;
  final String name;
  final String? targetId;

  static Target fromJson(dynamic content) {
    return Target(
        id: content['id'],
        name: content['name'],
        targetId: content['target_id']);
  }
}

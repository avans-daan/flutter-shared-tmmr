import 'target.dart';

class TimeEntry {
  TimeEntry(
      {required this.id,
      required this.description,
      required this.start,
      required this.stop,
      required this.target});

  final String id;
  final String? description;
  final DateTime start;
  final DateTime? stop;
  final Target? target;

  static TimeEntry fromJson(dynamic content) {
    return TimeEntry(
        id: content['id'],
        description: content['description'],
        start: DateTime.parse(content['start']),
        stop: content['stop'] != null ? DateTime.parse(content['stop']) : null,
        target: content['target'] != null ? Target.fromJson(content['target']) : null);
  }
}

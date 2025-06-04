import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/workplan.dart';

class ProjectComplete {
  final int id;
  final String title;
  final String description;
  final bool isConfirmed;
  final DateTime startDate;
  final DateTime? endDate;
  final User user;
  final Workplan? workplan;

  ProjectComplete({
    required this.id,
    required this.title,
    required this.description,
    required this.isConfirmed,
    required this.startDate,
    this.endDate,
    required this.user,
    this.workplan,
  });

  factory ProjectComplete.fromJson(Map<String, dynamic> json) {
    return ProjectComplete(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isConfirmed: json['active'] ?? false,
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      user: User.fromJson(json['creator']),
      workplan:
          json['workplan'] != null ? Workplan.fromJson(json['workplan']) : null,
    );
  }
}

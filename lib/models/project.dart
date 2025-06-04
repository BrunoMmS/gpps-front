import 'user.dart';

class Project {
  final int id;
  final String title;
  final String description;
  final bool active;
  final DateTime startDate;
  final DateTime? endDate;
  final User user;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.startDate,
    this.endDate,
    required this.user,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      active: json['active'],
      startDate: DateTime.parse(json['start_date']),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'description': description,
      'active': active,
      'start_date': startDate.toIso8601String(),
      'user_id': user.id,
    };

    if (endDate != null) {
      data['end_date'] = endDate!.toIso8601String();
    }
    return data;
  }
}

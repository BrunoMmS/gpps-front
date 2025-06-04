import 'activity.dart';

class Workplan {
  final int id;
  final String description;
  final List<Activity> activities;

  Workplan({
    required this.id,
    required this.description,
    required this.activities,
  });

  factory Workplan.fromJson(Map<String, dynamic> json) {
    return Workplan(
      id: json['id'],
      description: json['description'],
      activities:
          (json['activities'] as List)
              .map((activity) => Activity.fromJson(activity))
              .toList(),
    );
  }
}

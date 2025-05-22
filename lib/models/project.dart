class Project {
  final int id;
  final String title;
  final String description;
  final bool active;
  final DateTime startDate;
  final int userId;
  final DateTime? endDate;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.startDate,
    required this.userId,
    this.endDate,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      active: json['active'] as bool,
      startDate: DateTime.parse(json['start_date'] as String),
      userId: json['user_id'] as int,
      endDate:
          json['end_date'] != null
              ? DateTime.parse(json['end_date'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'description': description,
      'active': active,
      'start_date': startDate.toIso8601String(),
      'user_id': userId,
    };

    if (endDate != null) {
      data['end_date'] = endDate!.toIso8601String();
    }
    return data;
  }
}

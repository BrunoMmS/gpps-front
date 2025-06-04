import 'task.dart';

class Activity {
  final int id;
  final String name;
  final int duration;
  final bool done;
  final List<Task> tasks;

  Activity({
    required this.id,
    required this.name,
    required this.duration,
    required this.done,
    required this.tasks,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      done: json['done'],
      tasks:
          (json['tasks'] as List).map((task) => Task.fromJson(task)).toList(),
    );
  }
}

class ActivityCreate {
  final String name;
  final int duration;
  final bool done = false;

  ActivityCreate({required this.name, required this.duration});

  Map<String, dynamic> toJson() {
    return {'name': name, 'duration': duration, 'done': done};
  }
}

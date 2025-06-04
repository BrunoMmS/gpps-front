class Task {
  final int id;
  final String description;
  final bool done;

  Task({required this.id, required this.description, required this.done});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      done: json['done'],
    );
  }
}

class TaskCreate {
  final String description;

  TaskCreate({required this.description});

  Map<String, dynamic> toJson() {
    return {'description': description};
  }

  factory TaskCreate.fromJson(Map<String, dynamic> json) {
    return TaskCreate(description: json['description']);
  }
}

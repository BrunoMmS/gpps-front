import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskHandler {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<Task> createTask(
    int activityId,
    String description, {
    bool done = false,
  }) async {
    final url = Uri.parse('$baseUrl/activity/$activityId/task/create');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'description': description, 'done': done}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear la tarea: ${response.body}');
    }
  }

  Future<void> setDoneTask(
    int taskId,
  ) async {
    final url = Uri.parse('$baseUrl/activity/activities/task/$taskId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al actualizar el estado de la tarea: ${response.body}');
    }
  }
}

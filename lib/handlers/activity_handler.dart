import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/activity.dart';
import '../models/task.dart';

class ActivityHandler {
  final String baseUrl;

  ActivityHandler({required this.baseUrl});

  Future<Activity> createActivity(
    int workplanId,
    ActivityCreate activityData,
  ) async {
    final url = Uri.parse('$baseUrl/activity/create?workplan_id=$workplanId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(activityData.toJson()),
    );

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creando actividad: ${response.body}');
    }
  }

  Future<Task> createTaskForActivity(
    int activityId,
    TaskCreate taskData,
  ) async {
    final url = Uri.parse('$baseUrl/activity/$activityId/task/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creando tarea: ${response.body}');
    }
  }

  Future<List<Activity>> getActivitiesByWorkplan(int workplanId) async {
    final url = Uri.parse('$baseUrl/activity/workplan/$workplanId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Error obteniendo actividades: ${response.body}');
    }
  }
}

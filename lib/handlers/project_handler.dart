import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

class ProjectHandler {
  final String baseUrl;

  ProjectHandler({required this.baseUrl});

  Future<Project> createProject(Project project) async {
    final url = Uri.parse('$baseUrl/projects/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': project.title,
        'description': project.description,
        'active': project.active,
        'start_date': project.startDate.toIso8601String(),
        'user_id': project.userId,
        'end_date': project.endDate?.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error creando proyecto: ${response.body}');
    }
  }

  Future<List<Project>> listProjects() async {
    final url = Uri.parse('$baseUrl/projects/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Error listando proyectos: ${response.body}');
    }
  }

  Future<List<Project>> listProjectsByUser(int userId) async {
    final url = Uri.parse('$baseUrl/projects/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Error listando proyectos por usuario: ${response.body}');
    }
  }

  Future<void> assignUserToProject({
    required int userId,
    required int projectId,
    required int userToAssign,
  }) async {
    final url = Uri.parse('$baseUrl/projects/assignUserToProject');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'project_id': projectId,
        'user_to_assign': userToAssign,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error asignando usuario a proyecto: ${response.body}');
    }
  }

  Future<List<Project>> fetchInactiveProjects() async {
    final url = Uri.parse('$baseUrl/projects/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => Project.fromJson(json))
          .where((project) => !project.active)
          .toList();
    } else {
      throw Exception('Error al obtener proyectos inactivos');
    }
  }

  approveProject(int projectId) {
    final url = Uri.parse('$baseUrl/projects/approve/$projectId');
    return http
        .put(url)
        .then((response) {
          if (response.statusCode != 200) {
            throw Exception('Error al aprobar el proyecto: ${response.body}');
          }
        })
        .catchError((error) {
          throw Exception('Error al aprobar el proyecto: $error');
        });
  }
}

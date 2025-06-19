import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/project_complete.dart';
import 'package:http_parser/http_parser.dart';

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
        'user_id': project.user.id,
        'end_date': project.endDate?.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return await getProjectWithUser(json['id']);
    } else {
      throw Exception('Error creando proyecto: ${response.body}');
    }
  }

  Future<List<Project>> listProjects() async {
    final url = Uri.parse('$baseUrl/projects/all/WithUser');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map<Project>((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Error listando proyectos: ${response.body}');
    }
  }

  Future<List<Project>> listProjectsToAssign() async {
    final url = Uri.parse('$baseUrl/projects/getProjectsToAssign/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map<Project>((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Error listando proyectos: ${response.body}');
    }
  }

  Future<List<Project>> listProjectsByUser(int userId) async {
    final url = Uri.parse('$baseUrl/projects/getProjectsWithUser/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map<Project>((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Error listando proyectos por usuario: ${response.body}');
    }
  }

  Future<void> assignUserToProject({
    required int userId,
    required int projectId,
    required int userToAssign,
  }) async {
    final url = Uri.parse(
      '$baseUrl/projects/assignUserToProject'
      '?user_id=$userId&project_id=$projectId&user_to_assign=$userToAssign',
    );

    final response = await http.post(url); // No mandes body, ni headers

    if (response.statusCode != 200) {
      throw Exception('Error asignando usuario a proyecto: ${response.body}');
    }
  }

  Future<List<Project>> fetchInactiveProjects() async {
    final url = Uri.parse('$baseUrl/projects/all/WithUser');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList
          .map<Project>((json) => Project.fromJson(json))
          .where((project) => !project.active)
          .toList();
    }
    return [];
  }

  Future<void> approveProject(int projectId) async {
    final url = Uri.parse('$baseUrl/projects/approve/$projectId');
    final response = await http.put(url);

    if (response.statusCode != 200) {
      throw Exception('Error al aprobar el proyecto: ${response.body}');
    }
  }

  Future<Project> getProjectWithUser(int projectId) async {
    final url = Uri.parse(
      '$baseUrl/projects/project/getProjectWithUser/$projectId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Project.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Error obteniendo proyecto con usuario: ${response.body}',
      );
    }
  }

  Future<ProjectComplete> getProjectComplete(int projectId) async {
    final url = Uri.parse('$baseUrl/projects/projects/$projectId/complete');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ProjectComplete.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error obteniendo proyecto completo: ${response.body}');
    }
  }

  Future<void> createWorkplan({
    required int projectId,
    required String name,
  }) async {
    final url = Uri.parse('$baseUrl/projects/workplans/create');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'project_id': projectId, 'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error creando plan de trabajo: ${response.body}');
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    final url = Uri.parse('$baseUrl/upload/');
    final request = http.MultipartRequest('POST', url);

    if (file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.name,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );
    } else if (file.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          file.path!,
          contentType: MediaType('application', 'octet-stream'),
        ),
      );
    } else {
      throw Exception("No se pudo leer el archivo");
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception('Error subiendo archivo: $respStr');
    }
  }
}

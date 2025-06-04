import 'dart:convert';

import 'package:http/http.dart' as http;

class WorkplanHandler {
  final String baserUrl;

  WorkplanHandler({required this.baserUrl});

  Future<void> createWorkplan({
    required int userId,
    required int projectId,
    required String description,
  }) async {
    final uri = Uri.parse('$baserUrl/workplan/create?user_id=$userId');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'project_id': projectId, 'description': description}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear el plan de trabajo: ${response.body}');
    }
  }
}

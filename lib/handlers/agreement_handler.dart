import 'dart:convert';

import 'package:gpps_front/models/agreement.dart';
import 'package:http/http.dart' as http;

class AgreementHandler {
  final String baseUrl = "http://localhost:8000";

  Future<void> createAgreement(
    int creatorId,
    AgreementCreate agreementToCreate,
  ) async {
    final url = Uri.parse('$baseUrl/agreements/?creator_id=$creatorId');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': agreementToCreate.userId,
        'start_date': agreementToCreate.startDate.toIso8601String(),
        'end_date': agreementToCreate.endDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear el acuerdo: ${response.body}');
    }
  }

  Future<void> addTutorToAgreement(
    int agreementId,
    int tutorId,
    int userSelfId,
  ) async {
    final url = Uri.parse('$baseUrl/agreements/$agreementId/assign-user?user_id=$tutorId&asigner_id=$userSelfId');

    final response = await http.patch(url);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al añadir el tutor al acuerdo: ${response.body}');
    }
  }

  Future<List<Agreement>> getAllAgreements(
    int userSessionId,
  ) async {
    final url = Uri.parse('$baseUrl/agreements/created-by/$userSessionId?requester_id=$userSessionId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Agreement.fromJson(item)).toList().cast<Agreement>();
    } else {
      throw Exception('Error al obtener los convenios: ${response.body}');
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';

class NotificationHandler {
  static const String _baseUrl = 'http://localhost:8000/notification';

  static Future<List<Notification>> fetchNotifications(int userId) async {
    final response = await http.get(Uri.parse("$_baseUrl/$userId"));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Notification.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener notificaciones');
    }
  }

  static Future<void> markAsRead(int notifId) async {
    final response = await http.post(Uri.parse("$_baseUrl/read/$notifId"));

    if (response.statusCode != 200) {
      throw Exception('No se pudo marcar la notificación como leída');
    }
  }
}

import 'dart:convert';
import 'package:gpps_front/models/user_session.dart';
import 'package:http/http.dart' as http;
import 'package:gpps_front/models/user.dart';

class UserHandler {
  final String _baseUrl = const String.fromEnvironment(
    'BASE_URL_USER',
    defaultValue: 'http://127.0.0.1:8000/users',
  );

  Future<User?> login(UserLogin userLogin) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userLogin.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final user = User.fromJson(responseData);
      UserSession().login(user);
      return user;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error desconocido al iniciar sesión');
    }
  }

  Future<User?> register(UserCreate user) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error desconocido al registrarse');
    }
  }

  Future<User?> getUserById(int id) async {
    final url = Uri.parse('$_baseUrl/$id');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return User.fromJson(responseData);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['detail'] ?? 'Error desconocido al obtener usuario',
      );
    }
  }

  Future<List<User>> getAllUsers() async {
    final url = Uri.parse('$_baseUrl/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((user) => User.fromJson(user)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['detail'] ?? 'Error desconocido al obtener usuarios',
      );
    }
  }

  Future<List<User>> getUsersByRole(String role) async {
    final url = Uri.parse('$_baseUrl/');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData
          .where((user) => user['role'] == role)
          .map((user) => User.fromJson(user))
          .toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['detail'] ?? 'Error desconocido al obtener usuarios por rol',
      );
    }
  }
}

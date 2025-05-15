import 'dart:convert'; // Necesitamos importar esto para jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  User? _user;

  Future<void> login(User user) async {
    _user = user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    _user = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null;
}

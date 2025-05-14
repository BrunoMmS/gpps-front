import 'package:flutter/material.dart';
import 'package:gpps_front/models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginInterface extends StatefulWidget {
  const LoginInterface({super.key});

  @override
  State<LoginInterface> createState() => _LoginInterfaceState();
}

class _LoginInterfaceState extends State<LoginInterface> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  // Función para realizar el login
  Future<void> _loginUser() async {
    final url = Uri.parse(
      'http://127.0.0.1:8000/users/login',
    ); // Cambia esta URL por la real

    final userLogin = UserLogin(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userLogin.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String role = responseData['role'];
        final Map<String, String> roleRoutes = {
          'Administrador': '/dashboardAdmin',
          'Estudiante': '/dashboardStudent',
          'TutorUNRN': '/dashboardTutorUnrn',
          'TutorExterno': '/dashboardTutorExterno',
          'DirectorCarrera': '/dashboardDirector',
        };

        String? route = roleRoutes[role];
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else {
          _showError('Rol no reconocido');
        }
      } else {
        final error = jsonDecode(response.body);
        _showError(error['detail'] ?? 'Error desconocido');
      }
    } catch (e) {
      _showError('Error de conexión: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('❌ $message')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.blueGrey[800],
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "G.P.P.S",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Correo Electrónico",
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                        autofocus: true,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loginUser, // Llamar a la función de login
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              139,
                              208,
                              199,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Registrate aqui",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

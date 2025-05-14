import 'package:flutter/material.dart';
import 'package:gpps_front/models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterInterface extends StatefulWidget {
  const RegisterInterface({super.key});

  @override
  State<RegisterInterface> createState() => _RegisterInterfaceState();
}

class _RegisterInterfaceState extends State<RegisterInterface> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Estudiante';

  final List<String> _roles = [
    'Estudiante',
    'Tutor',
    'Administrador',
    'Entidad Externa',
    'Secretaría Académica',
  ];

  Future<void> _registerUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/users/register');

    final user = UserCreate(
      username: _usernameController.text,
      lastname: _nameController.text,
      email: _emailController.text,
      role: _selectedRole,
      password: _passwordController.text,
      id: 0,
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
        Navigator.pop(context);
      } else {
        // Si no es 200, muestra el error
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${error["detail"] ?? "desconocido"}'),
          ),
        );
      }
    } catch (e) {
      // Capturar errores de red o cualquier otro tipo de error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 450),
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
                      "¡¡ Únete a Nosotros !!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: "Nombre completo",
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: "Correo electrónico",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _usernameController,
                      label: "Nombre de usuario",
                      icon: Icons.account_circle,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Contraseña",
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    _buildRoleDropdown(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _registerUser, // Llama al método de registro
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Registrarse",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          ); // Regresa a la pantalla anterior
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
                        child: const Text(
                          "Volver a iniciar sesión",
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
    );
  }

  // Método para construir un campo de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Método para construir el Dropdown de roles
  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      items:
          _roles.map((role) {
            return DropdownMenuItem(value: role, child: Text(role));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value!; // Actualiza el rol seleccionado
        });
      },
      dropdownColor: Colors.blueGrey[700],
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Rol',
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(Icons.group, color: Colors.white54),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

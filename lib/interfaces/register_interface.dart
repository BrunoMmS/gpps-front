import 'package:flutter/material.dart';
import 'package:gpps_front/components/minimal_snackbar.dart';
import 'package:gpps_front/handlers/user_handler.dart';
import 'package:gpps_front/models/user.dart';

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

  final UserHandler _userHandler = UserHandler();

  Future<void> _registerUser() async {
    final user = UserCreate(
      username: _usernameController.text,
      lastname: _nameController.text,
      email: _emailController.text,
      role: _selectedRole,
      password: _passwordController.text,
      id: 0,
    );

    try {
      final registeredUser = await _userHandler.register(user);

      if (registeredUser != null) {
        showMinimalSnackBar(
          context,
          message: '✅ Registro exitoso',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        );
        Navigator.pop(context);
      } else {
        showMinimalSnackBar(
          context,
          message: '❌ Error: Usuario no registrado',
          icon: Icons.error_outline,
          color: Colors.redAccent,
        );
      }
    } catch (e) {
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
                        onPressed: _registerUser,
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
                          Navigator.pop(context);
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

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      items:
          _roles.map((role) {
            return DropdownMenuItem(value: role, child: Text(role));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value!;
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

void showMinimalSnackBar(
  BuildContext context, {
  required String message,
  IconData icon = Icons.info_outline,
  Color color = Colors.teal,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder:
        (context) =>
            MinimalSnackBar(message: message, icon: icon, color: color),
  );

  overlay.insert(overlayEntry);
  Future.delayed(duration, overlayEntry.remove);
}

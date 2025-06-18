import 'package:flutter/material.dart';
import 'package:gpps_front/handlers/agreement_handler.dart';
import 'package:gpps_front/handlers/user_handler.dart';
import 'package:gpps_front/models/rol_enum.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/agreement.dart';
import 'package:gpps_front/models/user_session.dart';

class Addtutor extends StatefulWidget {
  const Addtutor({super.key});

  @override
  State<Addtutor> createState() => _AddtutorState();
}

class _AddtutorState extends State<Addtutor> {
  // Instancias de los Handlers
  final AgreementHandler _agreementHandler = AgreementHandler();
  final UserHandler _userHandler = UserHandler(); // Nueva instancia para Users

  // Variables de estado para los datos de las listas desplegables
  List<Agreement> _agreements = [];
  Agreement? _selectedAgreement;
  List<User> _assignableUsers = []; // Renombrado de _tutors a _assignableUsers
  User? _selectedAssignableUser; // Renombrado de _selectedTutor

  // Variables de estado para el indicador de carga y el mensaje de visualización
  bool _isLoading = false; // Para la operación de asignación
  bool _isDataLoading = true; // Para la carga inicial de convenios y usuarios
  String? _message; // Para mostrar mensajes de éxito o error
  String? _dataErrorMessage; // Para errores al cargar los datos iniciales

  // ID del usuario actual, se obtiene de UserSession
  int? _userSelfId;

  // Color principal para los acentos (verde brillante de la imagen)
  final Color _accentGreen = const Color(0xFF00E676); // Un verde vibrante
  final Color _darkBackground = Colors.black;
  final Color _cardColor = Colors.grey[900]!;
  final Color _textColor = Colors.white;
  final Color _hintColor = Colors.grey[600]!;
  final Color _borderColor = Colors.grey[700]!;

  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Cargar convenios y usuarios asignables al iniciar
    _userSelfId = UserSession().user?.id; // Obtener ID del usuario de la sesión

    if (_userSelfId == null) {
      _message = 'Error: No hay una sesión de usuario activa.';
      print('DEBUG: UserSession().user es null. Asegúrate de iniciar sesión.');
    }
  }

  // Función para cargar los datos iniciales (convenios y usuarios asignables)
  Future<void> _fetchInitialData() async {
    setState(() {
      _isDataLoading = true;
      _dataErrorMessage = null;
    });

    try {
      final fetchedAgreements = await _agreementHandler.getAllAgreements(
        UserSession().user!.id,
      );

      // Cargar usuarios con roles de Administrador y Entidad Externa
      final List<User> fetchedUsers = [];
      fetchedUsers.addAll(await _userHandler.getUsersByRole(Rol.admin.backendValue));
      fetchedUsers.addAll(await _userHandler.getUsersByRole(Rol.exEntity.backendValue));

      setState(() {
        _agreements = fetchedAgreements;
        _assignableUsers = fetchedUsers; // Asigna los usuarios filtrados por rol
      });
    } catch (e) {
      setState(() {
        _dataErrorMessage = 'Error al cargar datos: ${e.toString()}';
        print('DEBUG: Error al cargar datos iniciales: $e');
      });
    } finally {
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Función para manejar el clic del botón y llamar a la API
  Future<void> _assignTutor() async { // El nombre del método aquí se mantiene por coherencia con el backend
    // Validaciones
    if (_userSelfId == null) {
      setState(() {
        _message = 'Error: Tu ID de usuario no está disponible.';
      });
      return;
    }
    if (_selectedAgreement == null) {
      setState(() {
        _message = 'Error: Por favor, selecciona un convenio.';
      });
      return;
    }
    if (_selectedAssignableUser == null) { // Renombrado aquí
      setState(() {
        _message = 'Error: Por favor, selecciona un usuario a asignar.'; // Mensaje actualizado
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final int agreementId = _selectedAgreement!.id;
      final int assignableUserId = _selectedAssignableUser!.id; // Renombrado aquí
      final int userSelfId = _userSelfId!;

      // La API espera tutorId, pero le estamos pasando el ID del usuario asignable
      await _agreementHandler.addTutorToAgreement(agreementId, assignableUserId, userSelfId);

      setState(() {
        _message = 'Usuario asignado exitosamente!'; // Mensaje actualizado
        _selectedAgreement = null; // Limpiar selección
        _selectedAssignableUser = null; // Limpiar selección
      });
    } catch (e) {
      setState(() {
        _message = e.toString().contains('Exception:')
            ? e.toString().replaceFirst('Exception:', 'Error:')
            : 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground,
      appBar: AppBar(
        title: const Text('Asignar Usuario al Convenio'), // Título de la AppBar actualizado
        backgroundColor: _darkBackground,
        foregroundColor: _textColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mensaje de error al cargar datos iniciales
            if (_isDataLoading)
              Center(
                child: CircularProgressIndicator(color: _accentGreen),
              )
            else if (_dataErrorMessage != null)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.red[900]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.red[700]!),
                ),
                child: Text(
                  _dataErrorMessage!,
                  style: TextStyle(color: Colors.red[200], fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            else ...[
              // Dropdown para seleccionar Convenio
              DropdownButtonFormField<Agreement>(
                value: _selectedAgreement,
                onChanged: (Agreement? newValue) {
                  setState(() {
                    _selectedAgreement = newValue;
                  });
                },
                isExpanded: true,
                dropdownColor: _cardColor, // Fondo del dropdown
                iconEnabledColor: _accentGreen, // Color del icono de la flecha
                decoration: InputDecoration(
                  labelText: 'Seleccionar Convenio',
                  labelStyle: TextStyle(color: _hintColor),
                  hintStyle: TextStyle(color: _hintColor),
                  prefixIcon: Icon(Icons.description, color: _accentGreen),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _accentGreen),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: _cardColor,
                ),
                style: TextStyle(color: _textColor), // Color del texto del elemento seleccionado
                items: _agreements.map<DropdownMenuItem<Agreement>>((Agreement agreement) {
                  return DropdownMenuItem<Agreement>(
                    value: agreement,
                    child: Text('Convenio ${agreement.id}', style: TextStyle(color: _textColor)),
                  );
                }).toList(),
                hint: Text('Selecciona un convenio', style: TextStyle(color: _hintColor)),
              ),
              const SizedBox(height: 16.0),

              // Dropdown para seleccionar Usuario a Asignar (antes Tutor)
              DropdownButtonFormField<User>(
                value: _selectedAssignableUser, // Renombrado
                onChanged: (User? newValue) {
                  setState(() {
                    _selectedAssignableUser = newValue; // Renombrado
                  });
                },
                isExpanded: true,
                dropdownColor: _cardColor,
                iconEnabledColor: _accentGreen,
                decoration: InputDecoration(
                  labelText: 'Seleccionar Usuario a Asignar', // ¡Texto cambiado!
                  labelStyle: TextStyle(color: _hintColor),
                  hintStyle: TextStyle(color: _hintColor),
                  prefixIcon: Icon(Icons.person_add, color: _accentGreen),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _borderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _accentGreen),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: _cardColor,
                ),
                style: TextStyle(color: _textColor),
                items: _assignableUsers.map<DropdownMenuItem<User>>((User user) { // Usamos _assignableUsers
                  String displayText = user.username;
                  // Aquí personalizamos el texto basado en el rol
                  if (user.role == Rol.admin.backendValue) { // Asume Rol.admin.backendValue es "Administrator"
                    displayText = 'Admin: ${user.username}';
                  } else if (user.role == Rol.exEntity.backendValue) { // Asume Rol.exEntity.backendValue es "ExternalEntity"
                    displayText = 'Entidad Externa: ${user.username}';
                  }
                  // Si hay otros roles, puedes añadir más 'else if'

                  return DropdownMenuItem<User>(
                    value: user,
                    // Muestra el nombre de usuario y su rol
                    child: Text(displayText, style: TextStyle(color: _textColor)),
                  );
                }).toList(),
                hint: Text('Selecciona un usuario a asignar', style: TextStyle(color: _hintColor)), // ¡Texto cambiado!
              ),
            ],
            const SizedBox(height: 24.0),

            // Botón para activar la asignación del usuario
            ElevatedButton.icon(
              // Deshabilitar si carga, no hay user ID, o no se han seleccionado convenio/usuario, o si los datos iniciales aún no se cargan
              onPressed: _isLoading || _userSelfId == null || _selectedAgreement == null || _selectedAssignableUser == null || _isDataLoading
                  ? null
                  : _assignTutor,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: _accentGreen,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Icon(Icons.send, color: Colors.black),
              label: Text(
                _isLoading ? 'Asignando...' : 'Asignar Usuario', // ¡Texto cambiado!
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24.0),

            // Área de visualización para mensajes de éxito o error de la operación
            if (_message != null)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: _message!.startsWith('Error') ? Colors.red[900]!.withOpacity(0.3) : _accentGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: _message!.startsWith('Error') ? Colors.red[700]! : _accentGreen,
                  ),
                ),
                child: Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.startsWith('Error') ? Colors.red[200] : _textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:gpps_front/handlers/agreement_handler.dart';
import 'package:gpps_front/handlers/user_handler.dart';
import 'package:gpps_front/models/agreement.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';

class CreateAgreementPage extends StatefulWidget {
  const CreateAgreementPage({Key? key}) : super(key: key);

  @override
  State<CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<CreateAgreementPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  List<User> _users = [];
  User? _selectedUser;
  bool _isLoading = false;
  String? _message;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await UserHandler().getAllUsers();
      setState(() => _users = users);
    } catch (e) {
      setState(() {
        _message = 'Error al cargar usuarios: $e';
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.tealAccent,
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[850],
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null &&
        _selectedUser != null) {
      setState(() {
        _isLoading = true;
        _message = null;
      });

      final creatorId = UserSession().user?.id;
      if (creatorId == null) {
        setState(() {
          _message = 'Usuario no autenticado.';
          _isLoading = false;
        });
        return;
      }

      final agreement = AgreementCreate(
        userId: _selectedUser!.id,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      try {
        await AgreementHandler().createAgreement(creatorId, agreement);
        setState(() {
          _message = '✅ Convenio creado exitosamente';
          _selectedUser = null;
          _startDate = null;
          _endDate = null;
        });
      } catch (e) {
        setState(() {
          _message = '❌ Error al crear el convenio: $e';
        });
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers =
        _users.where((u) {
          final searchLower = _searchQuery.toLowerCase();
          return u.username.toLowerCase().contains(searchLower) ||
              u.lastname.toLowerCase().contains(searchLower) ||
              u.role.toLowerCase().contains(searchLower);
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Convenio'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Buscar Usuario (nombre, apellido o rol):',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ej: juan tutor',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<User>(
                value: _selectedUser,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                items:
                    filteredUsers
                        .map(
                          (user) => DropdownMenuItem<User>(
                            value: user,
                            child: Text(
                              '${user.username} ${user.lastname} (${user.role})',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (user) => setState(() => _selectedUser = user),
                decoration: InputDecoration(
                  labelText: 'Seleccionar Usuario',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (user) =>
                        user == null ? 'Debe seleccionar un usuario' : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _selectDate(context, true),
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _startDate == null
                            ? 'Fecha Inicio'
                            : 'Inicio: ${_startDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _selectDate(context, false),
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        _endDate == null
                            ? 'Fecha Fin'
                            : 'Fin: ${_endDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[400],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text('Crear Convenio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              if (_message != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _message!,
                    style: TextStyle(
                      color:
                          _message!.contains('Error')
                              ? Colors.red[300]
                              : Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

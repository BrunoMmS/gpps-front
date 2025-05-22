import 'package:flutter/material.dart';
import '../../handlers/project_handler.dart';
import '../../models/project.dart';
import '../../models/user_session.dart';

class ProposeProjectPage extends StatefulWidget {
  const ProposeProjectPage({super.key});

  @override
  State<ProposeProjectPage> createState() => _ProposeProjectPageState();
}

class _ProposeProjectPageState extends State<ProposeProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _active = true;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  bool _isLoading = false;
  String? _errorMessage;

  late ProjectHandler _projectHandler;

  // Define colors based on the provided image
  final Color _backgroundColor = const Color(
    0xFF35444C,
  ); // Dark grey from the image background
  final Color _appBarColor = const Color(
    0xFF2E3B42,
  ); // Slightly darker grey for app bar
  final Color _tealColor = const Color(
    0xFF28A79A,
  ); // The prominent teal/green color
  final Color _textColor = Colors.white; // White text for contrast
  final Color _textFieldFillColor = const Color(
    0xFF4A5C64,
  ); // Slightly lighter grey for text field fill

  @override
  void initState() {
    super.initState();
    _projectHandler = ProjectHandler(baseUrl: 'http://127.0.0.1:8000');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: _tealColor, // Teal for selected date
              onPrimary: _textColor, // White text on teal
              surface: _backgroundColor, // Dark grey for calendar background
              onSurface: _textColor, // White text on background
            ),
            dialogBackgroundColor: _backgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: _tealColor,
              onPrimary: _textColor,
              surface: _backgroundColor,
              onSurface: _textColor,
            ),
            dialogBackgroundColor: _backgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserSession().user;
    if (user == null) {
      setState(() {
        _errorMessage = 'No hay usuario logueado.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newProject = Project(
        id: 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        active: _active,
        startDate: _startDate,
        userId: user.id,
        endDate: _endDate,
      );

      await _projectHandler.createProject(newProject);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Proyecto creado exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al crear proyecto: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Proponer Nuevo Proyecto'),
        backgroundColor: _appBarColor,
        foregroundColor: _textColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
                      filled: true,
                      fillColor: _textFieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: _tealColor, width: 2),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(color: _textColor),
                    cursorColor: _tealColor,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Campo obligatorio'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  // Descripción
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
                      filled: true,
                      fillColor: _textFieldFillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: _tealColor, width: 2),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(color: _textColor),
                    cursorColor: _tealColor,
                    minLines: 3,
                    maxLines: 5,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Campo obligatorio'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _textFieldFillColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Activo', style: TextStyle(color: _textColor)),
                        Switch(
                          activeColor: _tealColor,
                          inactiveThumbColor: _textColor.withOpacity(0.5),
                          inactiveTrackColor: _textColor.withOpacity(0.2),
                          value: _active,
                          onChanged: (val) {
                            setState(() {
                              _active = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _textFieldFillColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Fecha de inicio:',
                          style: TextStyle(color: _textColor),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => _selectStartDate(context),
                          style: TextButton.styleFrom(
                            foregroundColor: _tealColor,
                          ),
                          child: Text(
                            '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _textFieldFillColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Fecha de fin (opcional):',
                          style: TextStyle(color: _textColor),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => _selectEndDate(context),
                          style: TextButton.styleFrom(
                            foregroundColor: _tealColor,
                          ),
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'No seleccionada',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (_endDate != null)
                          IconButton(
                            icon: Icon(Icons.clear, color: _textColor),
                            onPressed: () {
                              setState(() {
                                _endDate = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF28A79A),
                        ),
                      )
                      : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tealColor,
                            foregroundColor: _textColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _submit,
                          child: const Text(
                            'Crear Proyecto',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

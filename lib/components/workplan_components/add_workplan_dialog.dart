import 'package:flutter/material.dart';

class AddWorkplanDialog extends StatefulWidget {
  final Function(String description) onCreate;

  const AddWorkplanDialog({super.key, required this.onCreate});

  @override
  State<AddWorkplanDialog> createState() => _AddWorkplanDialogState();
}

class _AddWorkplanDialogState extends State<AddWorkplanDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Crear plan de trabajo"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: "Descripción"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "La descripción no puede estar vacía";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onCreate(_descriptionController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text("Crear"),
        ),
      ],
    );
  }
}

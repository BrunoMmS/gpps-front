import 'package:flutter/material.dart';
import 'package:gpps_front/models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Tarea"),
      content: TextField(
        controller: descCtrl,
        decoration: const InputDecoration(labelText: "Descripción"),
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Agregar"),
          onPressed: () {
            final task = Task(
              id: DateTime.now().millisecondsSinceEpoch,
              description: descCtrl.text,
              done: false,
            );
            Navigator.pop(context, task);
          },
        ),
      ],
    );
  }
}

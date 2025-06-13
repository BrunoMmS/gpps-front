import 'package:flutter/material.dart';

import '../../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController descCtrl = TextEditingController();
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Tarea"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: descCtrl,
            decoration: const InputDecoration(labelText: "Descripción"),
          ),
          Row(
            children: [
              const Text("Completada"),
              Checkbox(
                value: done,
                onChanged: (value) {
                  setState(() {
                    done = value ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Agregar"),
          onPressed: () {
            if (descCtrl.text.trim().isEmpty) return;

            final task = TaskCreate(
              description: descCtrl.text.trim(),
              done: done,
            );
            Navigator.pop(context, task);
          },
        ),
      ],
    );
  }
}

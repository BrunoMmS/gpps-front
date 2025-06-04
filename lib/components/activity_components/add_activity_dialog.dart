import 'package:flutter/material.dart';
import 'package:gpps_front/models/activity.dart';

class AddActivityDialog extends StatefulWidget {
  const AddActivityDialog({super.key});

  @override
  State<AddActivityDialog> createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nueva Actividad"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: "Nombre"),
          ),
          TextField(
            controller: durationCtrl,
            decoration: const InputDecoration(labelText: "Duración (hs)"),
            keyboardType: TextInputType.number,
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
            final activity = ActivityCreate(
              name: nameCtrl.text,
              duration: int.tryParse(durationCtrl.text) ?? 0,
            );
            Navigator.pop(context, activity);
          },
        ),
      ],
    );
  }
}

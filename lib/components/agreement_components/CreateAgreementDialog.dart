import 'package:flutter/material.dart';
import 'package:gpps_front/models/agreement.dart';

class CreateAgreementDialog extends StatefulWidget {
  const CreateAgreementDialog({super.key});

  @override
  State<CreateAgreementDialog> createState() => _CreateAgreementDialogState();
}

class _CreateAgreementDialogState extends State<CreateAgreementDialog> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController userIdCtrl = TextEditingController();

  Future<void> pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? startDate ?? now : endDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Crear nuevo convenio"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text("Inicio: "),
              TextButton(
                onPressed: () => pickDate(isStart: true),
                child: Text(
                  startDate != null
                      ? "${startDate!.toLocal()}".split(' ')[0]
                      : "Elegir fecha",
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Fin: "),
              TextButton(
                onPressed: () => pickDate(isStart: false),
                child: Text(
                  endDate != null
                      ? "${endDate!.toLocal()}".split(' ')[0]
                      : "Elegir fecha",
                ),
              ),
            ],
          ),
          TextField(
            controller: userIdCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "User ID (opcional)"),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          onPressed:
              (startDate != null && endDate != null)
                  ? () {
                    final agreement = AgreementCreate(
                      startDate: startDate!,
                      endDate: endDate!,
                      userId:
                          userIdCtrl.text.isNotEmpty
                              ? int.tryParse(userIdCtrl.text)
                              : null,
                    );
                    Navigator.pop(context, agreement);
                  }
                  : null,
          child: const Text("Crear"),
        ),
      ],
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gpps_front/models/user_session.dart';
import '../handlers/project_handler.dart';

class FilePanel extends StatelessWidget {
  final int idUserCreator;
  const FilePanel({super.key, required this.idUserCreator});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (idUserCreator == UserSession().user!.id) ...[
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.white),
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.any,
              );
              if (result != null && result.files.isNotEmpty) {
                final file = result.files.first;
                try {
                  await ProjectHandler(
                    baseUrl: "http://127.0.0.1:8000",
                  ).uploadFile(file);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Archivo seleccionado: ${file.name}"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al subir archivo: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          const Text("Subir Archivo", style: TextStyle(color: Colors.white70)),
        ],
      ],
    );
  }
}

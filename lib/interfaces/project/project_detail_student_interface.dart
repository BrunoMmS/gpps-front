import 'package:flutter/material.dart';
import 'package:gpps_front/handlers/project_handler.dart';
import 'package:gpps_front/models/project_complete.dart';

import '../../components/workplan_components/add_workplan_dialog.dart';
import '../../components/workplan_components/workplan_panel.dart';
import '../../handlers/workplan_handler.dart';
import '../../models/user_session.dart';

class ProjectDetailPage extends StatefulWidget {
  final int projectId;
  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late Future<ProjectComplete> _projectFuture;
  ProjectComplete? _project;

  @override
  void initState() {
    super.initState();
    _projectFuture = ProjectHandler(
      baseUrl: "http://127.0.0.1:8000",
    ).getProjectComplete(widget.projectId);
  }

  void _createWorkplan() {
    showDialog(
      context: context,
      builder: (context) {
        return AddWorkplanDialog(
          onCreate: (String description) async {
            final user = UserSession().user;

            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Error: usuario no autenticado"),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            try {
              await WorkplanHandler(
                baserUrl: "http://127.0.0.1:8000",
              ).createWorkplan(
                userId: user.id,
                projectId: widget.projectId,
                description: description,
              );

              setState(() {
                _projectFuture = ProjectHandler(
                  baseUrl: "http://127.0.0.1:8000",
                ).getProjectComplete(widget.projectId);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Plan de trabajo creado exitosamente"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error al crear plan: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle del Proyecto"),
        backgroundColor: Colors.teal[700],
      ),
      backgroundColor: Colors.blueGrey[900],
      body: FutureBuilder<ProjectComplete>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró el proyecto'));
          }

          _project = snapshot.data!;
          final workplan = _project!.workplan;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _project!.title,
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  _project!.description,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      _project!.user.username,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      "Inicio: ${_project!.startDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    if (_project!.endDate != null) ...[
                      const SizedBox(width: 16),
                      Text(
                        "Fin: ${_project!.endDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),

                if (workplan == null) ...[
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add_chart),
                      label: const Text("Crear plan de trabajo"),
                      onPressed: _createWorkplan,
                    ),
                  ),
                ] else ...[
                  Expanded(child: WorkplanPanel(workplan: workplan)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

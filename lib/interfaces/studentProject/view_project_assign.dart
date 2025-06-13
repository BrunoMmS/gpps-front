import 'package:flutter/material.dart';
import '../../handlers/project_handler.dart';
import '../../models/project_complete.dart';
import '../../models/user_session.dart';

class ViewProjectAssign extends StatefulWidget {
  final int projectId;

  const ViewProjectAssign({super.key, required this.projectId});

  @override
  State<ViewProjectAssign> createState() => _ViewProjectAssignState();
}

class _ViewProjectAssignState extends State<ViewProjectAssign> {
  late Future<ProjectComplete> _projectFuture;
  final ProjectHandler _projectHandler = ProjectHandler(
    baseUrl: 'http://localhost:8000',
  );

  @override
  void initState() {
    super.initState();
    _projectFuture = _projectHandler.getProjectComplete(widget.projectId);
  }

  Future<void> _joinProject(ProjectComplete project) async {
    try {
      final userId = UserSession().user!.id;
      await _projectHandler.assignUserToProject(
        userId: userId,
        projectId: project.id,
        userToAssign: userId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Te uniste al proyecto correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al unirse: $e')));
    }
  }

  Widget _buildProjectDetail(ProjectComplete project) {
    final Color cardColor = const Color(0xFF2C2C3E);
    final Color accentColor = Colors.tealAccent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Descripción:\n${project.description}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Creador: ${project.user.username} ${project.user.lastname} (${project.user.role})",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Inicio: ${project.startDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (project.endDate != null)
                    Text(
                      "Fin: ${project.endDate!.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _joinProject(project),
                      icon: const Icon(Icons.login, color: Colors.black),
                      label: const Text(
                        "Unirse al proyecto",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Actividades",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          ...project.workplan!.activities.map(
            (activity) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...activity.tasks.map(
                    (task) => Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.greenAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              task.description,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E2C);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Detalles del Proyecto',
          style: TextStyle(color: Colors.white60),
        ),
        backgroundColor: const Color(0xFF2C2C3E),
        elevation: 0,
      ),
      body: FutureBuilder<ProjectComplete>(
        future: _projectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.tealAccent),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return _buildProjectDetail(snapshot.data!);
        },
      ),
    );
  }
}

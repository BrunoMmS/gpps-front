import 'package:flutter/material.dart';
import '../../handlers/project_handler.dart';
import '../../models/project.dart';
import '../../models/user_session.dart';
import 'view_project_assign.dart';

class ProjectAssign extends StatefulWidget {
  const ProjectAssign({super.key});

  @override
  State<ProjectAssign> createState() => _ProjectAssignState();
}

class _ProjectAssignState extends State<ProjectAssign> {
  final ProjectHandler _projectHandler = ProjectHandler(
    baseUrl: 'http://localhost:8000',
  );

  late Future<List<Project>> _projectsFuture;
  final int _currentUserId = UserSession().user!.id;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _projectHandler.listProjects();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF1E1E2C);
    final Color cardColor = const Color(0xFF2C2C3E);
    final Color accentColor = Colors.tealAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        title: const Text(
          "Unirse a proyectos",
          style: TextStyle(color: Colors.white60),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<Project>>(
        future: _projectsFuture,
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

          final filteredProjects =
              snapshot.data!
                  .where(
                    (project) =>
                        project.active && project.user.id != _currentUserId,
                  )
                  .toList();

          if (filteredProjects.isEmpty) {
            return const Center(
              child: Text(
                "No hay proyectos disponibles",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredProjects.length,
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              return Card(
                color: cardColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${project.user.username} ${project.user.lastname} (${project.user.role})",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.greenAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Activo",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login, color: Colors.black),
                          label: const Text(
                            "Unirse",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ViewProjectAssign(
                                      projectId: project.id,
                                    ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

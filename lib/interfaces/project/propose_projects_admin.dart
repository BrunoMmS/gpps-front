import 'package:flutter/material.dart';
import '../../handlers/project_handler.dart';
import '../../models/project.dart';

class InactiveProjectsPage extends StatefulWidget {
  const InactiveProjectsPage({super.key});

  @override
  State<InactiveProjectsPage> createState() => _InactiveProjectsPageState();
}

class _InactiveProjectsPageState extends State<InactiveProjectsPage> {
  late Future<List<Project>> _futureProjects;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  void _fetchProjects() {
    _futureProjects =
        ProjectHandler(
          baseUrl: 'http://localhost:8000',
        ).fetchInactiveProjects();
    _futureProjects.then((projects) {
      if (projects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay proyectos inactivos')),
        );
      }
    });
  }

  Future<void> approveProject(int projectId) async {
    try {
      await ProjectHandler(
        baseUrl: 'http://localhost:8000',
      ).approveProject(projectId);
      setState(() => _fetchProjects());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proyecto aprobado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al aprobar: $e')));
    }
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      color: const Color(0xFF1E2A38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título del proyecto
            Text(
              project.title,
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              project.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24),

            // Información del usuario creador
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white60, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${project.user.username} ${project.user.lastname}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    project.user.role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Fecha de inicio
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white60,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Inicio: ${project.startDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón de aprobar
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => approveProject(project.id),
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text(
                  'Aprobar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3E50),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2A38),
        title: const Text(
          'Proyectos Inactivos',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Project>>(
        future: _futureProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final projects = snapshot.data ?? [];

          if (projects.isEmpty) {
            return const Center(
              child: Text(
                'No hay proyectos inactivos.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) => _buildProjectCard(projects[index]),
          );
        },
      ),
    );
  }
}

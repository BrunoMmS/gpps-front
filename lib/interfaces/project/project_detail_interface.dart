import 'package:flutter/material.dart';
import 'package:gpps_front/models/project.dart';
import 'package:gpps_front/models/user_session.dart';

import '../../models/user.dart';
import '../../handlers/user_handler.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      backgroundColor: Colors.blueGrey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.blueGrey[800],
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  project.description,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: Colors.blueGrey[600]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      project.active ? Icons.check_circle : Icons.cancel,
                      color:
                          project.active
                              ? Colors.greenAccent
                              : Colors.redAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      project.active ? "Activo" : "Inactivo",
                      style: TextStyle(
                        fontSize: 18,
                        color:
                            project.active
                                ? Colors.greenAccent
                                : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Fecha inicio: ${project.startDate.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (project.endDate != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Fecha fin: ${project.endDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    CreatorName(projectUserId: project.userId),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreatorName extends StatelessWidget {
  final int projectUserId;

  const CreatorName({super.key, required this.projectUserId});

  @override
  Widget build(BuildContext context) {
    final userSession = UserSession();
    final currentUserId = userSession.user?.id;
    final userHandler = UserHandler();
    if (projectUserId == currentUserId) {
      return const Text(
        "Tú",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      );
    } else {
      return FutureBuilder<User?>(
        future: userHandler.getUserById(projectUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              "Cargando...",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            );
          } else if (snapshot.hasError) {
            return const Text(
              "Error al cargar",
              style: TextStyle(color: Colors.redAccent, fontSize: 16),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            return Text(
              snapshot.data!.username,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            );
          } else {
            return const Text(
              "Desconocido",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            );
          }
        },
      );
    }
  }
}

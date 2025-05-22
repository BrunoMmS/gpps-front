import 'package:flutter/material.dart';
import 'package:gpps_front/components/logout_button.dart';
import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/models/rol_enum.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';
import '../../models/project.dart';
import '../../components/project_row.dart';
import '../../handlers/project_handler.dart';

class DashboardStudent extends StatefulWidget {
  const DashboardStudent({super.key});

  @override
  _DashboardStudentState createState() => _DashboardStudentState();
}

class _DashboardStudentState extends State<DashboardStudent> {
  User? user;
  List<Project> projects = [];
  late ProjectHandler projectHandler;

  @override
  void initState() {
    super.initState();
    projectHandler = ProjectHandler(baseUrl: 'http://127.0.0.1:8000');
    _loadUserAndProjects();
  }

  Future<void> _loadUserAndProjects() async {
    await UserSession().loadUser();
    setState(() {
      user = UserSession().user;
    });
    if (user != null) {
      try {
        final userProjects = await projectHandler.listProjectsByUser(user!.id);
        setState(() {
          projects = userProjects;
        });
      } catch (e) {
        print('Error cargando proyectos: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF1C1F26);
    final sidebarColor = const Color(0xFF2A2F3A);
    final appBarColor = const Color(0xFF1A1D24);
    final textColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Estudiante"),
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        centerTitle: true,
        elevation: 4,
        actions: [LogoutButton(), const SizedBox(width: 60)],
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel lateral estilizado
              Container(
                width: 300,
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sidebarColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus Proyectos',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          projects.isEmpty
                              ? Center(
                                child: Text(
                                  user == null
                                      ? "Cargando proyectos..."
                                      : "Aún no has creado proyectos.",
                                  style: TextStyle(color: Colors.white60),
                                ),
                              )
                              : ListView.separated(
                                itemCount: projects.length,
                                separatorBuilder:
                                    (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final project = projects[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[700],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ProjectRow(project: project),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Panel principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    if (user != null)
                      WelcomeBanner(
                        name: user!.username,
                        role:
                            RolExtension.fromBackendValue(
                              user!.role,
                            )?.displayName ??
                            user!.role,
                      ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.count(
                        padding: const EdgeInsets.all(24),
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        children: [
                          DashboardButton(
                            icon: Icons.notifications_active_outlined,
                            label: "Notificaciones",
                            onTap: () {},
                          ),
                          DashboardButton(
                            icon: Icons.assignment_add,
                            label: "Inscribirse",
                            onTap: () {},
                          ),
                          DashboardButton(
                            icon: Icons.lightbulb_outline,
                            label: "Proponer Proyecto",
                            onTap: () {
                              Navigator.pushNamed(context, '/proposeProject');
                            },
                          ),
                          DashboardButton(
                            icon: Icons.track_changes,
                            label: "Seguimiento PPS",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

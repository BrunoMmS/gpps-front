import 'package:flutter/material.dart';

// Components
import 'package:gpps_front/components/logout_button.dart';
import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/components/notification_button.dart';
import 'package:gpps_front/components/project_row.dart';

// Models
import 'package:gpps_front/models/rol_enum.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';
import 'package:gpps_front/models/project.dart';

// Handlers
import 'package:gpps_front/handlers/project_handler.dart';

class DashboardStudent extends StatefulWidget {
  const DashboardStudent({super.key});

  @override
  _DashboardStudentState createState() => _DashboardStudentState();
}

class _DashboardStudentState extends State<DashboardStudent> {
  User? user;
  List<Project> projects = [];
  late ProjectHandler projectHandler;

  final backgroundColor = const Color(0xFF1C1F26);
  final sidebarColor = const Color(0xFF2A2F3A);
  final appBarColor = const Color(0xFF1A1D24);
  final textColor = Colors.white;

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
        print("Error al cargar proyectos: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Panel del Estudiante"),
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        centerTitle: true,
        elevation: 4,
        actions: const [
          NotificationButton(),
          LogoutButton(),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSidebar(),
                const SizedBox(width: 24),
                _buildMainContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: sidebarColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tus Proyectos',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                projects.isEmpty
                    ? Center(
                      child: Text(
                        user == null
                            ? "Cargando proyectos..."
                            : "Aún no has creado proyectos.",
                        style: const TextStyle(color: Colors.white60),
                        textAlign: TextAlign.center,
                      ),
                    )
                    : ListView.separated(
                      itemCount: projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return ProjectRow(project: projects[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null)
            WelcomeBanner(
              name: user!.username,
              role:
                  RolExtension.fromBackendValue(user!.role)?.displayName ??
                  user!.role,
            ),
          const SizedBox(height: 20),
          const Text(
            "Acciones disponibles",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.6,
              ),
              children: [
                DashboardButton(
                  icon: Icons.assignment_add,
                  label: "Inscribirse",
                  onTap: () {
                    Navigator.pushNamed(context, '/ViewProjectsAssigns');
                    // lógica para inscripción
                  },
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
                  onTap: () {
                    Navigator.pushNamed(context, '/projectDetails');
                    // lógica para seguimiento PPS
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

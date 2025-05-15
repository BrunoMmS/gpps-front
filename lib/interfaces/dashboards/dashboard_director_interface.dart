import 'package:flutter/material.dart';
import 'package:gpps_front/components/logout_button.dart';
import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';

class DashboardDirector extends StatefulWidget {
  const DashboardDirector({super.key});

  @override
  State<DashboardDirector> createState() => _DashboardDirectorState();
}

class _DashboardDirectorState extends State<DashboardDirector> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await UserSession().loadUser();
    setState(() {
      user = UserSession().user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Director"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [LogoutButton()],
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              if (user != null)
                WelcomeBanner(name: user!.username, role: user!.role),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(24),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: [
                    DashboardButton(
                      icon: Icons.visibility,
                      label: "Ver Proyectos",
                      onTap: () {},
                    ),
                    DashboardButton(
                      icon: Icons.bar_chart,
                      label: "Estadísticas PPS",
                      onTap: () {},
                    ),
                    DashboardButton(
                      icon: Icons.file_present,
                      label: "Reportes",
                      onTap: () {},
                    ),
                    DashboardButton(
                      icon: Icons.group,
                      label: "Gestión Usuarios",
                      onTap: () {},
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

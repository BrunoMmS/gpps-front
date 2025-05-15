import 'package:flutter/material.dart';
import 'package:gpps_front/components/logout_button.dart';

import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';

class DashboardStudent extends StatefulWidget {
  const DashboardStudent({super.key});

  @override
  _DashboardStudentState createState() => _DashboardStudentState();
}

class _DashboardStudentState extends State<DashboardStudent> {
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
        title: const Text("Panel del Estudiante"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [LogoutButton(), SizedBox(width: 60)],
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
                      icon: Icons.notifications,
                      label: "Notificaciones",
                      onTap: () {},
                    ),
                    DashboardButton(
                      icon: Icons.library_add,
                      label: "Inscribirse",
                      onTap: () {},
                    ),
                    DashboardButton(
                      icon: Icons.lightbulb_outline,
                      label: "Proponer Proyecto",
                      onTap: () {},
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
      ),
    );
  }
}

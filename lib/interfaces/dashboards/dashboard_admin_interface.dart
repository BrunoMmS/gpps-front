import 'package:flutter/material.dart';
import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/logout_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
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
        title: const Text(
          'Panel de Administrador',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
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
                      icon: Icons.check_circle_outline,
                      label: 'Evaluar Proyecto',
                      onTap: () {
                        Navigator.pushNamed(context, '/evaluar_proyecto');
                      },
                    ),
                    DashboardButton(
                      icon: Icons.publish_outlined,
                      label: 'Publicar Proyecto',
                      onTap: () {
                        Navigator.pushNamed(context, '/publicar_proyecto');
                      },
                    ),
                    DashboardButton(
                      icon: Icons.lightbulb_outline,
                      label: 'Ver Propuestas',
                      onTap: () {
                        Navigator.pushNamed(context, '/propuestas');
                      },
                    ),
                    DashboardButton(
                      icon: Icons.notifications_active_outlined,
                      label: 'Enviar Notificación',
                      onTap: () {
                        Navigator.pushNamed(context, '/enviar_notificacion');
                      },
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

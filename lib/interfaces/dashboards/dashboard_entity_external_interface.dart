import 'package:flutter/material.dart';
import 'package:gpps_front/components/dashboard_button.dart';
import 'package:gpps_front/components/logout_button.dart';
import 'package:gpps_front/components/notification_button.dart';
import 'package:gpps_front/components/welcome_banner.dart';
import 'package:gpps_front/models/user.dart';
import 'package:gpps_front/models/user_session.dart';

class DashboardExternal extends StatefulWidget {
  const DashboardExternal({Key? key}) : super(key: key);

  @override
  State<DashboardExternal> createState() => _DashboardExternalState();
}

class _DashboardExternalState extends State<DashboardExternal> {
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
          'Panel de Entidad Externa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[900],
        centerTitle: true,
        actions: [NotificationButton(), LogoutButton()],
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
                      icon: Icons.assignment_outlined,
                      label: 'Crear Convenio',
                      onTap: () {
                        Navigator.pushNamed(context, '/createAgreement');
                      },
                    ),
                    DashboardButton(
                      icon: Icons.supervisor_account_outlined,
                      label: 'Asignar Usuario',
                      onTap: () {
                        Navigator.pushNamed(context, '/asignar_tutor');
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

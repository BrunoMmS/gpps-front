import 'package:flutter/material.dart';
import 'package:gpps_front/components/dashboard_button.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

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
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
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
      ),
    );
  }
}

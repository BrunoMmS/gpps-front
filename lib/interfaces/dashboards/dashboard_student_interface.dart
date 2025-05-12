import 'package:flutter/material.dart';
import 'package:gpps_front/components/dashboard_button.dart';

class DashboardStudent extends StatelessWidget {
  const DashboardStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Estudiante"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
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
      ),
    );
  }
}

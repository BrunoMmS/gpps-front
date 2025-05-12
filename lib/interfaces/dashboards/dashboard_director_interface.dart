import 'package:flutter/material.dart';
import 'package:gpps_front/components/dashboard_button.dart';

class DashboardDirector extends StatelessWidget {
  const DashboardDirector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel del Director"),
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
      ),
    );
  }
}

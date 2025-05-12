import 'package:flutter/material.dart';
import 'package:gpps_front/interfaces/dashboards/dashboard_admin_interface.dart';
import 'package:gpps_front/interfaces/dashboards/dashboard_director_interface.dart';
import 'package:gpps_front/interfaces/dashboards/dashboard_student_interface.dart';
import 'package:gpps_front/interfaces/login_interface.dart';
import 'package:gpps_front/interfaces/register_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Practicas Profesionalizantes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 183, 175),
        ),
      ),
      home: LoginInterface(),
      routes: {
        '/register': (context) => const RegisterInterface(),
        '/dashboardStudent': (context) => const DashboardStudent(),
        '/dashboardAdmin': (context) => const DashboardAdmin(),
        '/dashboardDirector': (context) => const DashboardDirector(),
      },
    );
  }
}

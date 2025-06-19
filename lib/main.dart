import 'package:flutter/material.dart';
import 'package:gpps_front/components/agreement_components/CreateAgreementPage.dart';
import 'package:gpps_front/interfaces/Unauthorized.dart';
import 'package:gpps_front/interfaces/agreements_pages/addtutor.dart';
import 'package:gpps_front/interfaces/dashboards/dashboard_admin_interface.dart';
import 'package:gpps_front/interfaces/dashboards/dashboard_student_interface.dart';
import 'package:gpps_front/interfaces/login_interface.dart';
import 'package:gpps_front/interfaces/project/project_detail_student_interface.dart';
import 'package:gpps_front/interfaces/project/propose_project_interface.dart';
import 'package:gpps_front/interfaces/project/propose_projects_admin.dart';
import 'package:gpps_front/interfaces/register_interface.dart';
import 'package:gpps_front/models/rol_enum.dart';
import 'package:gpps_front/role_guard.dart';

import 'interfaces/dashboards/dashboard_entity_external_interface.dart';
import 'interfaces/studentProject/project_assign.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de Practicas Profesionalizantes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 58, 183, 175),
        ),
      ),
      home: const LoginInterface(),

      routes: {
        '/register': (context) => const RegisterInterface(),
        '/login': (context) => const LoginInterface(),
        '/dashboardExternalEntity':
            (context) => RoleGuard(
              allowedRoles: [
                Rol.exEntity.backendValue,
                Rol.student.backendValue,
              ],
              child: const DashboardExternal(),
            ),
        '/dashboardStudent':
            (context) => RoleGuard(
              allowedRoles: [Rol.student.backendValue],
              child: const DashboardStudent(),
            ),

        '/dashboardAdmin':
            (context) => RoleGuard(
              allowedRoles: [Rol.admin.backendValue],
              child: const DashboardAdmin(),
            ),

        '/unauthorized': (context) => const UnauthorizedPage(),

        '/proposeProject':
            (context) => RoleGuard(
              allowedRoles: [Rol.student.backendValue, Rol.admin.backendValue],
              child: const ProposeProjectPage(),
            ),
        '/projectDetails': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return RoleGuard(
            allowedRoles: [
              Rol.student.backendValue,
              Rol.admin.backendValue,
              Rol.exEntity.backendValue,
            ],
            child: ProjectDetailPage(projectId: args),
          );
        },
        '/proposeProjectsAdmin':
            (context) => RoleGuard(
              allowedRoles: [Rol.admin.backendValue, Rol.exEntity.backendValue],
              child: const InactiveProjectsPage(),
            ),
        '/ViewProjectsAssigns':
            (context) => RoleGuard(
              allowedRoles: [
                Rol.admin.backendValue,
                Rol.exEntity.backendValue,
                Rol.student.backendValue,
              ],
              child: const ProjectAssign(),
            ),
        '/ViewProjectAssing':
            (context) => RoleGuard(
              allowedRoles: [Rol.student.backendValue],
              child: const ProjectAssign(),
            ),
        '/createAgreement': (context) {
          return RoleGuard(
            allowedRoles: [Rol.exEntity.backendValue, Rol.student.backendValue, Rol.admin.backendValue],
            child: CreateAgreementPage(),
          );
        },
        '/asignar_tutor': (context) {
          return RoleGuard(
            allowedRoles: [Rol.exEntity.backendValue, Rol.admin.backendValue],
            child: Addtutor(),
          );
        },
      },
    );
  }
}

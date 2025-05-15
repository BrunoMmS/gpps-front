import 'package:flutter/material.dart';
import 'package:gpps_front/models/user_session.dart';

class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const RoleGuard({super.key, required this.child, required this.allowedRoles});

  @override
  Widget build(BuildContext context) {
    final user = UserSession().user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox();
    }

    if (!allowedRoles.contains(user.role)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/unauthorized');
      });
      return const SizedBox();
    }

    return child;
  }
}

import 'package:gpps_front/models/User.dart';
import 'package:gpps_front/models/project.dart';

import 'agreement_status.dart';

class Agreement {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  bool? current;
  User createdBy;
  User user;
  Project project;
  AgreementStatus status;

  Agreement({
    required this.id,
    required this.startDate,
    required this.endDate,
    this.current,
    required this.createdBy,
    required this.user,
    required this.project,
    required this.status,
  });
}

class AgreementCreate {
  final DateTime startDate;
  final DateTime endDate;
  final int? userId;

  AgreementCreate({
    required this.startDate,
    required this.endDate,
    this.userId,
  });
}

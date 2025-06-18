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

  static Agreement fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      current: json['current'],
      createdBy: User.fromJson(json['created_by']),
      user: User.fromJson(json['user']),
      project: Project.fromJson(json['project']),
      status: fromString(json['status']),
    );
  }
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

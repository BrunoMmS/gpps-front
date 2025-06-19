import 'package:gpps_front/models/User.dart';

class Agreement {
  final int id;

  final String? title;
  final String? description;
  final bool? active;
  final DateTime? startDate;
  final DateTime? endDate;
  final User? user; // ¡CAMBIO CLAVE AQUÍ! Ahora es nullable
  // ^^^^^^^^^^^ (Cambió de 'User' a 'User?')

  final bool? current;
  final User? createdBy;

  Agreement({
    required this.id,
    this.title,
    this.description,
    this.active,
    this.startDate,
    this.endDate,
    this.user, // ¡CAMBIO CLAVE AQUÍ! Ya no es 'required'
    this.current,
    this.createdBy,
  });

  static Agreement fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      active: json['active'] as bool?,
      startDate: parseDate(json['start_date']),
      endDate: parseDateSafely(json['end_date']),
      // ¡CAMBIO CLAVE AQUÍ! Manejo seguro para 'user'
      user: (json['user'] is Map<String, dynamic>)
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null, // Si 'user' no es un mapa o es null, asigna null
      
      current: json.containsKey('current') ? json['current'] as bool? : null,
      // ¡CAMBIO CLAVE AQUÍ! Manejo seguro para 'createdBy'
      createdBy: (json['created_by'] is Map<String, dynamic>)
          ? User.fromJson(json['created_by'] as Map<String, dynamic>)
          : null, // Si 'created_by' no es un mapa o es null, asigna null
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

// Helper functions for date parsing (no necesitan cambios)
DateTime? parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}

DateTime? parseDateSafely(dynamic value) {
  try {
    return parseDate(value);
  } catch (_) {
    return null;
  }
}
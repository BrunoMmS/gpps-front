enum Rol { student, exEntity, teacher, teacher2, admin }

extension RolExtension on Rol {
  String get backendValue {
    switch (this) {
      case Rol.student:
        return "Student";
      case Rol.exEntity:
        return "ExternalEntity";
      case Rol.teacher:
        return "Teacher_UNRN";
      case Rol.teacher2:
        return "ExternalTeacher";
      case Rol.admin:
        return "Administrator";
    }
  }

  String get displayName {
    switch (this) {
      case Rol.student:
        return "Estudiante";
      case Rol.exEntity:
        return "Entidad Externa";
      case Rol.teacher:
        return "Tutor";
      case Rol.teacher2:
        return "Profesor Externo";
      case Rol.admin:
        return "Administrador";
    }
  }

  static Rol? fromDisplayName(String displayName) {
    try {
      return Rol.values.firstWhere((r) => r.displayName == displayName);
    } catch (e) {
      return null;
    }
  }

  static Rol? fromBackendValue(String backendValue) {
    try {
      return Rol.values.firstWhere((r) => r.backendValue == backendValue);
    } catch (e) {
      return null;
    }
  }
}

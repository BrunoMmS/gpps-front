enum Rol { student, exEntity, inteacher, exteacher, admin }

extension RolExtension on Rol {
  String get backendValue {
    switch (this) {
      case Rol.student:
        return "Student";
      case Rol.exEntity:
        return "ExternalEntity";
      case Rol.inteacher:
        return "Teacher_UNRN";
      case Rol.exteacher:
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
      case Rol.inteacher:
        return "Tutor";
      case Rol.exteacher:
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

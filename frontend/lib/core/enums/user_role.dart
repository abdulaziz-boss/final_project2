enum UserRole {
  superAdmin,
  admin,
  user,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.superAdmin:
        return "super_admin";
      case UserRole.admin:
        return "admin";
      case UserRole.user:
        return "user";
    }
  }
}
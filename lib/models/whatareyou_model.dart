enum UserRole { parent, caregiverOrganization }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.parent:
        return 'parent';
      case UserRole.caregiverOrganization:
        return 'Caregiver / Organization';
    }
  }
}
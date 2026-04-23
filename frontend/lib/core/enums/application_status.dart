enum ApplicationStatus {
  pending,
  accepted,
  rejected,
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get value {
    switch (this) {
      case ApplicationStatus.pending:
        return "pending";
      case ApplicationStatus.accepted:
        return "accepted";
      case ApplicationStatus.rejected:
        return "rejected";
    }
  }
}
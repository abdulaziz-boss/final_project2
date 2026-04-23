enum OpportunityStatus {
  open,
  closed,
}

extension OpportunityStatusExtension on OpportunityStatus {
  String get value {
    switch (this) {
      case OpportunityStatus.open:
        return "open";
      case OpportunityStatus.closed:
        return "closed";
    }
  }
}
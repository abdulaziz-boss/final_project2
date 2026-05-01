class ApplicationModel {
  final int id;
  final int userId;
  final int opportunityId;
  final String status;
  final String? alasan;
  final DateTime? createdAt;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.opportunityId,
    required this.status,
    this.alasan,
    this.createdAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      userId: json['user_id'],
      opportunityId: json['opportunity_id'],
      status: json['status'] ?? 'pending',
      alasan: json['alasan'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "opportunity_id": opportunityId,
      "alasan": alasan,
    };
  }
}
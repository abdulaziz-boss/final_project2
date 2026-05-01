class LikeModel {
  final int userId;
  final int opportunityId;

  LikeModel({
    required this.userId,
    required this.opportunityId,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      userId: json['user_id'],
      opportunityId: json['opportunity_id'],
    );
  }
} 
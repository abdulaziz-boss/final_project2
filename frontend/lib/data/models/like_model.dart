class LikeModel {
  final int userId;
  final int opportunityId;

  LikeModel({
    required this.userId,
    required this.opportunityId,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      // 🔥 Amankan ID User yang melakukan Like
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : (int.tryParse(json['user_id'].toString()) ?? 0),

      // 🔥 Amankan ID Opportunity yang di-Like
      opportunityId: json['opportunity_id'] is int 
          ? json['opportunity_id'] 
          : (int.tryParse(json['opportunity_id'].toString()) ?? 0),
    );
  }
} 
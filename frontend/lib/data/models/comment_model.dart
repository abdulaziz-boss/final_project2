import 'package:frontend_final/data/models/user_model.dart';

class CommentModel {
  final int id;
  final int userId;
  final int opportunityId;
  final String comment;
  final int? parentId;
  final DateTime createdAt;
  final UserModel user;

  CommentModel({
    required this.id,
    required this.userId,
    required this.opportunityId,
    required this.comment,
    this.parentId,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      // 🔥 Amankan ID Utama komentar
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan ID User yang berkomentar
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : (int.tryParse(json['user_id'].toString()) ?? 0),

      // Amankan ID Opportunity (Pola disamakan agar lebih clean)
      opportunityId: json['opportunity_id'] is int 
          ? json['opportunity_id'] 
          : (int.tryParse(json['opportunity_id'].toString()) ?? 0),

      comment: json['comment'] ?? '',

      // 🔥 Amankan Parent ID untuk reply komentar (bisa bernilai null)
      parentId: json['parent_id'] != null
          ? (json['parent_id'] is int 
              ? json['parent_id'] as int 
              : int.tryParse(json['parent_id'].toString()))
          : null,

      createdAt: json['created_at'] != null
          ? (DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now())
          : DateTime.now(),

      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
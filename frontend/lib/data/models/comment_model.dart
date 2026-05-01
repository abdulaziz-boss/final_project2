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
      id: json['id'],
      userId: json['user_id'],
      opportunityId: int.parse(json['opportunity_id'].toString()),
      comment: json['comment'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
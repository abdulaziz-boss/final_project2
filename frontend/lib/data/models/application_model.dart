import 'user_model.dart';

class ApplicationModel {
  final int id;
  final int userId;
  final int opportunityId;
  final String status;
  final String? alasan;
  final UserModel? user;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.opportunityId,
    required this.status,
    this.alasan,
    this.user,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      userId: json['user_id'],
      opportunityId: json['opportunity_id'],
      status: json['status'],
      alasan: json['alasan'],
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }

  ApplicationModel copyWith({
    int? id,
    int? userId,
    int? opportunityId,
    String? status,
    String? alasan,
    UserModel? user,
  }) {
    return ApplicationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      opportunityId: opportunityId ?? this.opportunityId,
      status: status ?? this.status,
      alasan: alasan ?? this.alasan,
      user: user ?? this.user,
    );
  }
}
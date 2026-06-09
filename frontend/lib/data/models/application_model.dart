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
      // 🔥 Amankan ID Utama dari String database hosting
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan Foreign Keys int agar tidak bentrok
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : (int.tryParse(json['user_id'].toString()) ?? 0),

      opportunityId: json['opportunity_id'] is int 
          ? json['opportunity_id'] 
          : (int.tryParse(json['opportunity_id'].toString()) ?? 0),

      status: json['status'] ?? 'pending',
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
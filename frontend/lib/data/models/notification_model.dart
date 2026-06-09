class NotificationModel {
  final int id;
  final int userId;
  final String judul;
  final String isi;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.judul,
    required this.isi,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      // 🔥 Amankan ID Utama Notifikasi
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan ID User pemilik notifikasi
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : (int.tryParse(json['user_id'].toString()) ?? 0),

      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      
      // Keamanan boolean bawaanmu sudah top! Kita tambahkan pengecekan string '1' sekalian biar super aman
      isRead: json['is_read'] == 1 || 
              json['is_read'] == true || 
              json['is_read'].toString() == '1',
              
      createdAt: json['created_at'] ?? '',
    );
  }
}

class MessageModel {
  final int id;
  final int conversationId;
  final int senderId;
  final String message;
  final String createdAt;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      // 🔥 Amankan ID Utama (Konversi otomatis jika berupa string)
      id: json['id'] is int 
          ? json['id'] 
          : (int.tryParse(json['id'].toString()) ?? 0),

      // 🔥 Amankan Foreign Keys agar tidak type mismatch
      conversationId: json['conversation_id'] is int 
          ? json['conversation_id'] 
          : (int.tryParse(json['conversation_id'].toString()) ?? 0),

      senderId: json['sender_id'] is int 
          ? json['sender_id'] 
          : (int.tryParse(json['sender_id'].toString()) ?? 0),

      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
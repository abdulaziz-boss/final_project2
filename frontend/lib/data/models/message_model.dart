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
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender_id'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}
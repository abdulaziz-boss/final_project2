class ConversationModel {
  final int id;
  final int user1Id;
  final int user2Id;
  final String? user1Name;
  final String? user2Name;
  final String? user1Photo;
  final String? user2Photo;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? lastMessageSenderId;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.user1Name,
    this.user2Name,
    this.user1Photo,
    this.user2Photo,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    // Ambil pesan terakhir dari relasi 'latest_message' atau 'messages' jika ada
    String? lastMsg;
    String? lastMsgTime;
    int? lastMsgSenderId;
    if (json['latest_message'] != null) {
      lastMsg = json['latest_message']['message'];
      lastMsgTime = json['latest_message']['created_at'];
      lastMsgSenderId = json['latest_message']['sender_id'];
    } else if (json['messages'] != null && (json['messages'] as List).isNotEmpty) {
      lastMsg = json['messages'][0]['message'];
      lastMsgTime = json['messages'][0]['created_at'];
      lastMsgSenderId = json['messages'][0]['sender_id'];
    }

    return ConversationModel(
      id: json['id'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      user1Name: json['user1'] != null ? json['user1']['name'] : null,
      user2Name: json['user2'] != null ? json['user2']['name'] : null,
      user1Photo: json['user1'] != null ? json['user1']['foto_profil'] : null,
      user2Photo: json['user2'] != null ? json['user2']['foto_profil'] : null,
      lastMessage: lastMsg ?? json['last_message'],
      lastMessageTime: lastMsgTime,
      lastMessageSenderId: lastMsgSenderId,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../providers/chat_provider.dart';

class ChatRepository {
  final ChatProvider provider;

  ChatRepository(this.provider);

  Future<List<ConversationModel>> getConversations() async {
    final res = await provider.getConversations();

    return (res.data['data'] as List)
        .map((e) => ConversationModel.fromJson(e))
        .toList();
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final res = await provider.getMessages(conversationId);

    return (res.data['data'] as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();
  }

  Future<void> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    await provider.sendMessage(
      conversationId: conversationId,
      message: message,
    );
  }

  Future<ConversationModel> startConversation(int receiverId) async {
    final res = await provider.startConversation(receiverId);
    return ConversationModel.fromJson(res.data['data']);
  }
}
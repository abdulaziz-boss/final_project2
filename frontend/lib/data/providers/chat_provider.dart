import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

class ChatProvider {
  final api = ApiService();

  Future<Response> getConversations() async {
    return await api.dio.get(ApiConstants.conversations);
  }

  Future<Response> getMessages(int conversationId) async {
    return await api.dio.get('${ApiConstants.conversations}/$conversationId/messages');
  }

  Future<Response> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    return await api.dio.post(
      '${ApiConstants.conversations}/$conversationId/messages',
      data: {
        'message': message,
      },
    );
  }

  Future<Response> startConversation(int receiverId) async {
    return await api.dio.post(
      ApiConstants.conversations,
      data: {
        'receiver_id': receiverId,
      },
    );
  }
}
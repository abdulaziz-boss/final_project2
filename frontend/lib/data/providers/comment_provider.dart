import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class CommentProvider {
  final api = ApiService();

  // 🔥 GET COMMENTS (PAGINATED)
  Future<Response> getComments(int opportunityId, {int page = 1}) async {
    return await api.dio.get(
      'opportunities/$opportunityId/comments',
      queryParameters: {'page': page},
    );
  }

  // 🔥 CREATE COMMENT
  Future<Response> createComment({
    required int opportunityId,
    required String comment,
    int? parentId,
  }) async {
    return await api.dio.post(
      'opportunities/$opportunityId/comments',
      data: {
        "comment": comment,
        if (parentId != null) "parent_id": parentId,
      },
    );
  }
}
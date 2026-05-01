import '../models/comment_model.dart';
import '../providers/comment_provider.dart';

class CommentRepository {
  final provider = CommentProvider();

  // 🔥 GET COMMENTS (PAGINATED)
  Future<List<CommentModel>> getComments(int opportunityId, {int page = 1}) async {
    try {
      final res = await provider.getComments(opportunityId, page: page);
      final dynamic responseData = res.data;

      List? listData;

      if (responseData is List) {
        listData = responseData;
      } else if (responseData is Map && responseData['data'] != null) {
        listData = responseData['data'];
      }

      if (listData == null) {
        print("COMMENT REPO: Format data tidak dikenali. Response: $responseData");
        return [];
      }

      return listData.map((e) => CommentModel.fromJson(e)).toList();
    } catch (e) {
      print("ERROR COMMENT REPO: $e");
      return [];
    }
  }

  // 🔥 CREATE COMMENT
  Future<bool> createComment({
    required int opportunityId,
    required String comment,
    int? parentId,
  }) async {
    try {
      await provider.createComment(
        opportunityId: opportunityId,
        comment: comment,
        parentId: parentId,
      );
      return true;
    } catch (e) {
      print("ERROR CREATE COMMENT: $e");
      return false;
    }
  }
}
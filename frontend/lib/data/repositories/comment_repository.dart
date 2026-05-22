  import '../models/comment_model.dart';
  import '../providers/comment_provider.dart';

  class CommentRepository {
    final provider = CommentProvider();

    // 🔥 GET COMMENTS (PAGINATED)
    Future<List<CommentModel>> getComments(int opportunityId, {int page = 1}) async {
      try {
        final res = await provider.getComments(opportunityId, page: page);
        final dynamic responseData = res.data;
        print("DEBUG COMMENT REPO: Raw Response for ID $opportunityId -> $responseData");

        List? listData;

        if (responseData is List) {
          listData = responseData;
        } else if (responseData is Map && responseData['data'] != null) {
          final dataField = responseData['data'];
          if (dataField is List) {
            listData = dataField;
          } else if (dataField is Map && dataField['data'] != null && dataField['data'] is List) {
            listData = dataField['data'];
          }
        }

        print("DEBUG COMMENT REPO: Parsed List Data Length -> ${listData?.length ?? 0}");

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
    Future<CommentModel?> createComment({
      required int opportunityId,
      required String comment,
      int? parentId,
    }) async {
      try {
        final res = await provider.createComment(
          opportunityId: opportunityId,
          comment: comment,
          parentId: parentId,
        );
        
        final data = res.data['data'];
        if (data != null) {
          return CommentModel.fromJson(data);
        }
        return null;
      } catch (e) {
        print("ERROR CREATE COMMENT: $e");
        return null;
      }
    }
  }
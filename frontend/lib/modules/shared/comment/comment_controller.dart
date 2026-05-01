import 'package:get/get.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _repo = CommentRepository();

  var comments = <CommentModel>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var page = 1;
  var hasMore = true;

  final int opportunityId;

  CommentController(this.opportunityId);

  @override
  void onInit() {
    super.onInit();
    fetchComments();
  }

  // 🔥 FETCH COMMENTS (PAGINATED)
  Future<void> fetchComments({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      page = 1;
      comments.clear();
      hasMore = true;
    }

    if (!hasMore) return;

    isLoading.value = true;

    final newComments = await _repo.getComments(
      opportunityId,
      page: page,
    );

    if (newComments.isEmpty) {
      hasMore = false;
    } else {
      page++;
      comments.addAll(newComments);
    }

    isLoading.value = false;
  }

  // 🔥 LOAD MORE (PAGINATION)
  Future<void> loadMore() async {
    if (!hasMore || isLoading.value) return;
    await fetchComments();
  }

  // 🔥 SEND COMMENT
  Future<void> sendComment(String text, {int? parentId}) async {
    if (text.trim().isEmpty) return;

    isSending.value = true;

    final success = await _repo.createComment(
      opportunityId: opportunityId,
      comment: text.trim(),
      parentId: parentId,
    );

    if (success) {
      // Refresh semua komentar agar dapat data terbaru dari server
      await fetchComments(refresh: true);
    } else {
      Get.snackbar("Error", "Gagal mengirim komentar");
    }

    isSending.value = false;
  }
}
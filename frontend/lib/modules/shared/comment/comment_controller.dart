import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/comment_model.dart';
import '../../../data/repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _repo = CommentRepository();

  var comments = <CommentModel>[].obs;
  var totalComments = 0.obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var page = 1;
  var hasMore = true;

  final int opportunityId;

  CommentController(this.opportunityId);

  @override
  void onInit() {
    super.onInit();
    // Memastikan data selalu segar saat controller dibuat
    fetchComments(refresh: true);
  }

  // 🔥 FETCH COMMENTS (PAGINATED)
  Future<void> fetchComments({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;

    print("DEBUG COMMENT CONTROLLER: Fetching comments for ID $opportunityId (Refresh: $refresh)");

    if (refresh) {
      page = 1;
      hasMore = true;
      // Jangan clear dulu agar tidak kedip (jika sudah ada data)
    }

    if (!hasMore) return;

    isLoading.value = true;

    final newComments = await _repo.getComments(
      opportunityId,
      page: page,
    );

    if (newComments.isEmpty) {
      hasMore = false;
      if (refresh) comments.clear(); // Jika memang kosong, bersihkan
    } else {
      page++;
      if (refresh) {
        comments.assignAll(newComments); // Ganti semua data
      } else {
        comments.addAll(newComments); // Tambah data (pagination)
      }
    }

    // Update total count jika ada data dari meta atau length
    if (refresh) {
       // Jika backend belum support total di json, kita pake length sementara
       // Tapi idealnya backend kirim 'total' di pagination
    }
    
    isLoading.value = false;
  }

  // 🔥 LOAD MORE (PAGINATION)
  Future<void> loadMore() async {
    if (!hasMore || isLoading.value) return;
    await fetchComments();
  }

  // 🔥 SEND COMMENT (OPTIMISTIC)
  Future<void> sendComment(String text, {int? parentId}) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final storage = StorageService();
    final userData = storage.getUserData();
    
    // 1. Buat Komentar Sementara (Optimistic)
    final tempUser = userData != null 
        ? UserModel.fromJson(userData)
        : UserModel(id: 0, name: "Anda", username: "user", email: "", isVerified: false);

    final tempComment = CommentModel(
      id: -1, // Penanda sementara
      userId: tempUser.id,
      opportunityId: opportunityId,
      comment: trimmedText,
      createdAt: DateTime.now(),
      user: tempUser,
    );

    // Langsung tampil di UI (masukkan ke paling atas)
    comments.insert(0, tempComment);
    totalComments.value++;
    
    isSending.value = true;
    final createdComment = await _repo.createComment(
      opportunityId: opportunityId,
      comment: trimmedText,
      parentId: parentId,
    );

    if (createdComment != null) {
      // Ganti komentar sementara dengan yang asli dari server (biar ID-nya bener)
      final index = comments.indexWhere((c) => c.id == -1);
      if (index != -1) {
        comments[index] = createdComment;
      }
    } else {
      // Rollback jika gagal
      comments.removeWhere((c) => c.id == -1);
      totalComments.value--;
      Get.snackbar("Error", "Gagal mengirim komentar");
    }
    
    isSending.value = false;
  }
}
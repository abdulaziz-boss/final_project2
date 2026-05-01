import 'package:get/get.dart';
import '../../../data/repositories/like_repository.dart';

class LikeController extends GetxController {
  final LikeRepository _repo = LikeRepository();

  var isLiked = false.obs;
  var totalLikes = 0.obs;
  var isLoading = false.obs;

  final int opportunityId;

  LikeController(this.opportunityId);

  @override
  void onInit() {
    super.onInit();
    loadLikeStatus();
  }

  // 🔥 LOAD STATUS LIKE
  Future<void> loadLikeStatus() async {
    isLoading.value = true;
    final data = await _repo.getLikeStatus(opportunityId);
    isLiked.value = data['is_liked'] ?? false;
    totalLikes.value = data['total'] ?? 0;
    isLoading.value = false;
  }

  // 🔥 TOGGLE LIKE (OPTIMISTIC UPDATE)
  Future<void> toggleLike() async {
    // Simpan state lama untuk rollback
    final oldLiked = isLiked.value;
    final oldTotal = totalLikes.value;

    // Optimistic update: ubah UI dulu
    isLiked.value = !isLiked.value;
    totalLikes.value += isLiked.value ? 1 : -1;
    if (totalLikes.value < 0) totalLikes.value = 0;

    // Kirim ke server
    final success = await _repo.toggleLike(opportunityId);

    if (!success) {
      // Rollback jika gagal
      isLiked.value = oldLiked;
      totalLikes.value = oldTotal;
      Get.snackbar("Error", "Gagal mengubah like");
    }
  }
}
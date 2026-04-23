import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/models/feed_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/opportunity_model.dart';
import '../../data/repositories/post_repository.dart';
import '../../data/repositories/opportunity_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final postRepo = PostRepository();
  final opportunityRepo = OpportunityRepository();
  final authRepo = AuthRepository();
  final storage = StorageService();

  var feeds = <FeedModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchFeeds();
    super.onInit();
  }

  Future<void> fetchFeeds() async {
    try {
      isLoading.value = true;

      final posts = await postRepo.getAll();
      final opportunities = await opportunityRepo.getAll();

      List<FeedModel> temp = [];

      temp.addAll(posts.map((e) => FeedModel(type: FeedType.post, data: e)));

      temp.addAll(
        opportunities.map(
          (e) => FeedModel(type: FeedType.opportunity, data: e),
        ),
      );

      feeds.value = temp;
    } catch (e) {
      print("ERROR HOME: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin mau keluar?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await storage.clearToken();
    Get.offAllNamed('/login');
  }
}

import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/repositories/post_repository.dart';

class PostController extends GetxController {
  final repo = PostRepository();

  var posts = <PostModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;

      final data = await repo.getAll();
      posts.value = data;

    } catch (e) {
      print("ERROR POST CONTROLLER: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
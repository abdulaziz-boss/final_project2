import '../models/post_model.dart';
import '../providers/post_provider.dart';

class PostRepository {
  final provider = PostProvider();

  Future<List<PostModel>> getAll() async {
    try {
      final res = await provider.getAll();

      final List data = res.data['data'];

      return data.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      print("ERROR POST: $e");
      return [];
    }
  }
}
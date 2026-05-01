import '../providers/like_provider.dart';

class LikeRepository {
  final provider = LikeProvider();

  // 🔥 GET LIKE STATUS + TOTAL
  Future<Map<String, dynamic>> getLikeStatus(int opportunityId) async {
    try {
      final res = await provider.getLikeStatus(opportunityId);
      final data = res.data;

      if (data is Map<String, dynamic>) {
        return {
          'is_liked': data['is_liked'] ?? false,
          'total': data['total'] ?? 0,
        };
      }

      return {'is_liked': false, 'total': 0};
    } catch (e) {
      print("ERROR LIKE REPO: $e");
      return {'is_liked': false, 'total': 0};
    }
  }

  // 🔥 TOGGLE LIKE
  Future<bool> toggleLike(int opportunityId) async {
    try {
      await provider.toggleLike(opportunityId);
      return true;
    } catch (e) {
      print("ERROR TOGGLE LIKE: $e");
      return false;
    }
  }
}
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class LikeProvider {
  final api = ApiService();

  // 🔥 GET STATUS LIKE
  Future<Response> getLikeStatus(int opportunityId) async {
    return await api.dio.get('opportunities/$opportunityId/likes');
  }

  // 🔥 TOGGLE LIKE
  Future<Response> toggleLike(int opportunityId) async {
    return await api.dio.post('opportunities/$opportunityId/like');
  }
}
import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class UserProvider {
  final ApiService _api = ApiService();

  Future<Response> getUserProfile(int id) async {
    return await _api.dio.get('/users/$id');
  }

  Future<Response> updateProfile(int id, dynamic data) async {
    return await _api.dio.post(
      '/users/$id',
      data: data,
    ); // Usually POST for multipart
  }

  Future<Response> requestUpgrade(dynamic data) async {
    return await _api.dio.post('/organization', data: data);
  }
}

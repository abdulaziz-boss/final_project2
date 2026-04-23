import 'package:dio/dio.dart';

class UserProvider {
  final Dio dio = Dio();

  final String baseUrl = "http://YOUR_API_URL/api";

  Future<Response> getUserProfile(int id) async {
    return await dio.get('$baseUrl/users/$id');
  }

  Future<Response> updateProfile(int id, Map<String, dynamic> data) async {
    return await dio.put('$baseUrl/users/$id', data: data);
  }
}
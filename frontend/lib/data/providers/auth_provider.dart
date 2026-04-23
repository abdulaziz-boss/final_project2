import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class AuthProvider {
  final ApiService api = ApiService();

  Future<Response> login(String email, String password) async {
    return await api.dio.post(
      "/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await api.dio.post("/register", data: data);
  }

  Future<Response> loginWithGoogle(String idToken) async {
    return await api.dio.post(
      "/auth/google",
      data: {
        "id_token": idToken,
      },
    );
  }

  Future<Response> logout() async {
    return await api.dio.post('/logout');
  }
}
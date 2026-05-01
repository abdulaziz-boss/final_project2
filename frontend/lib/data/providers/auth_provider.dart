import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

class AuthProvider {
  final ApiService api = ApiService();

  Future<Response> login(String email, String password) async {
    return await api.dio.post(
      ApiConstants.login,
      data: {"email": email, "password": password},
    );
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await api.dio.post(ApiConstants.register, data: data);
  }

  Future<Response> loginWithGoogle(String idToken) async {
    return await api.dio.post(
      ApiConstants.googleLogin,
      data: {
        "token":
            idToken, // 🔥 Diubah dari id_token ke token agar sesuai backend
      },
    );
  }

  Future<Response> logout() async {
    return await api.dio.post('/logout');
  }
}

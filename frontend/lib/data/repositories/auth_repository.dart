import 'package:dio/dio.dart';
import '../providers/auth_provider.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final AuthProvider provider = AuthProvider();
  final StorageService storage = StorageService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await provider.login(email, password);

      final data = response.data;
      
      // Ambil token (cek berbagai kemungkinan struktur JSON)
      String? token;
      if (data['data'] != null && data['data']['token'] != null) {
        token = data['data']['token']['access_token'];
      }
      token ??= data['access_token'] ?? data['token'];

      if (token == null) {
        print("LOGIN ERROR: Token is null. Response: $data");
        return false;
      }

      await storage.saveToken(token);
      return true;
    } on DioException catch (e) {
      print("LOGIN DIO ERROR: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      print("LOGIN UNKNOWN ERROR: $e");
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await provider.register(data);

      final res = response.data;

      // Biasanya Laravel return status success atau data objek
      if (res == null) return false;
      
      // Jika ada field status, cek success. Jika tidak, asumsikan sukses jika dapet response data.
      if (res['status'] != null && res['status'] != 'success') {
        print("REGISTER ERROR: ${res['message']}");
        return false;
      }

      return true;
    } on DioException catch (e) {
      print("REGISTER DIO ERROR: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      print("REGISTER REPO ERROR: $e");
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      final response = await provider.loginWithGoogle(idToken);

      final data = response.data;
      
      // Ambil token (cek berbagai kemungkinan struktur JSON)
      String? token;
      if (data['data'] != null && data['data']['token'] != null) {
        token = data['data']['token']['access_token'];
      }
      token ??= data['access_token'] ?? data['token'];

      if (token == null) {
        print("GOOGLE LOGIN ERROR: Token is null. Response: $data");
        return false;
      }

      await storage.saveToken(token);
      return true;
    } on DioException catch (e) {
      print("GOOGLE LOGIN DIO ERROR: ${e.response?.data ?? e.message}");
      return false;
    } catch (e) {
      print("GOOGLE LOGIN ERROR: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await provider.logout();
      await storage.clearToken();
    } catch (e) {
      print("LOGOUT API ERROR: $e");
    }
  }
}
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
        throw Exception("Token tidak valid dari server.");
      }

      final userData = data['data']?['user'] ?? data['user'];
      final userRole = userData?['role'] ?? 'user';

      await storage.saveUserData(
        token: token,
        role: userRole,
        user: userData,
      );
      return true;
    } on DioException catch (e) {
      print("LOGIN DIO ERROR: ${e.response?.data ?? e.message}");
      String errorMessage = 'Login gagal';
      if (e.response?.data != null) {
        final resData = e.response!.data;
        if (resData['message'] != null) {
          errorMessage = resData['message'].toString();
        } else if (resData['errors'] != null) {
          final errors = resData['errors'] as Map<String, dynamic>;
          final messages = [];
          errors.forEach((key, value) {
            if (value is List) {
              messages.addAll(value);
            } else {
              messages.add(value.toString());
            }
          });
          if (messages.isNotEmpty) {
            errorMessage = messages.join('\n');
          }
        }
      } else {
        errorMessage = e.message ?? 'Koneksi ke server terganggu';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print("LOGIN UNKNOWN ERROR: $e");
      throw Exception(e.toString());
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await provider.register(data);

      final res = response.data;

      if (res == null) {
        throw Exception("Response kosong dari server.");
      }
      
      if (res['status'] != null && res['status'] != 'success') {
        throw Exception(res['message'] ?? "Register gagal");
      }

      return true;
    } on DioException catch (e) {
      print("REGISTER DIO ERROR: ${e.response?.data ?? e.message}");
      String errorMessage = 'Register gagal';
      if (e.response?.data != null) {
        final resData = e.response!.data;
        if (resData['errors'] != null) {
          final errors = resData['errors'] as Map<String, dynamic>;
          final messages = [];
          errors.forEach((key, value) {
            if (value is List) {
              messages.addAll(value);
            } else {
              messages.add(value.toString());
            }
          });
          if (messages.isNotEmpty) {
            errorMessage = messages.join('\n');
          }
        } else if (resData['message'] != null) {
          errorMessage = resData['message'].toString();
        }
      } else {
        errorMessage = e.message ?? 'Koneksi ke server terganggu';
      }
      throw Exception(errorMessage);
    } catch (e) {
      print("REGISTER REPO ERROR: $e");
      throw Exception(e.toString());
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

      final userData = data['data']?['user'] ?? data['user'];
      final userRole = userData?['role'] ?? 'user';

      await storage.saveUserData(
        token: token,
        role: userRole,
        user: userData,
      );
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
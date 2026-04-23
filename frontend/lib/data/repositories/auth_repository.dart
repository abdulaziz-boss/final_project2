import '../providers/auth_provider.dart';
import '../../core/services/storage_service.dart';

class AuthRepository {
  final AuthProvider provider = AuthProvider();
  final StorageService storage = StorageService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await provider.login(email, password);

      final token = response.data['access_token'];

      await storage.saveToken(token);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await provider.register(data);

      final res = response.data;

      if (res == null || res['status'] != 'success') {
        return false;
      }

      return true;
    } catch (e) {
      print("REPO ERROR: $e");
      return false;
    }
  }

  Future<bool> loginWithGoogle(String idToken) async {
    try {
      final response = await provider.loginWithGoogle(idToken);

      final token = response.data['access_token'];

      await storage.saveToken(token);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await provider.logout(); // kalau backend ada endpoint logout
    } catch (e) {
      print("LOGOUT API ERROR: $e");
    }
  } 
}
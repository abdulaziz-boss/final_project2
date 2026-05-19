import 'package:get_storage/get_storage.dart';

class StorageService {
  final box = GetStorage();

  Future<void> saveToken(String token) async {
    await box.write('token', token);
  }

  String? getToken() {
    return box.read('token');
  }

  String? getRole() {
    return box.read('role');
  }

  Future<void> clearToken() async {
    await box.remove('token');
    await box.remove('role');
    await box.remove('user_data');
  }

  Future<void> logout() => clearToken();

  Future<void> saveUserData({
    required String token,
    required String role,
    Map<String, dynamic>? user,
  }) async {
    await box.write('token', token);
    await box.write('role', role);
    if (user != null) {
      await box.write('user_data', user);
    }
  }

  Map<String, dynamic>? getUserData() {
    return box.read('user_data');
  }

  Future<Map<String, dynamic>?> getUser() async => getUserData();
}
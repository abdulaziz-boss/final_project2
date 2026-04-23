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
  }

  Future<void> saveUserData({
    required String token,
    required String role,
  }) async {
    await box.write('token', token);
    await box.write('role', role);
  }
}
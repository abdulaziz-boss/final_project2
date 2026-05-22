import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider provider = UserProvider();

  Future<Map<String, dynamic>> getUserProfile(int id) async {
    final response = await provider.getUserProfile(id);
    return response
        .data['data']; // Returns ['user': UserModel, 'opportunities': List]
  }

  Future<UserModel> updateProfile(int id, dynamic data) async {
    final response = await provider.updateProfile(id, data);
    return UserModel.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> requestUpgrade(Map<String, dynamic> data) async {
    final response = await provider.requestUpgrade(data);
    return response.data;
  }
}

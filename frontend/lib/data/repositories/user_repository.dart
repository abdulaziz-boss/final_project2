import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserRepository {
  final UserProvider provider = UserProvider();

  Future<UserModel> getUserProfile(int id) async {
    final response = await provider.getUserProfile(id);

    final data = response.data['data']; // sesuaikan API kamu

    return UserModel.fromJson(data);
  }

  Future<UserModel> updateProfile(int id, Map<String, dynamic> data) async {
    final response = await provider.updateProfile(id, data);

    final result = response.data['data'];

    return UserModel.fromJson(result);
  }
}
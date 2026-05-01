import '../models/application_model.dart';
import '../providers/application_provider.dart';

class ApplicationRepository {
  final provider = ApplicationProvider();

  // 🔥 APPLY
  Future<void> apply(int opportunityId, {String? alasan}) async {
    final response = await provider.apply(opportunityId, alasan: alasan);

    final res = response.data;

    if (res['status'] != 'success') {
      throw Exception(res['message'] ?? "Gagal apply");
    }
  }

  // 🔥 GET MY APPLICATIONS
  Future<List<ApplicationModel>> getMyApplications() async {
    final response = await provider.getMyApplications();

    final List data = response.data['data'];

    return data.map((e) => ApplicationModel.fromJson(e)).toList();
  }

  // 🔥 CHECK SUDAH APPLY
  Future<ApplicationModel?> check(int opportunityId) async {
    try {
      final response = await provider.checkApplication(opportunityId);

      final res = response.data;

      if (res['data'] == null) return null;

      return ApplicationModel.fromJson(res['data']);
    } catch (e) {
      return null;
    }
  }
}
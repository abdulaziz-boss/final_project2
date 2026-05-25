import 'package:dio/dio.dart';
import '../models/application_model.dart';
import '../../core/services/api_service.dart';

class ApplicationRepository {

  final api = ApiService().dio;

  // apply volunteer
  Future<void> apply(int opportunityId) async {

    await api.post(
      '/applications/$opportunityId',
    );
  }

  // cek status apply
  Future<ApplicationModel?> check(
      int opportunityId) async {

    final response = await api.get(
      '/applications/$opportunityId',
    );

    final data = response.data['data'];

    if (data == null) {
      return null;
    }

    return ApplicationModel.fromJson(data);
  }

  // admin lihat participants
  Future<List<ApplicationModel>>
      getParticipants(int opportunityId) async {

    final response = await api.get(
      '/applications/participants/$opportunityId',
    );

    final List data = response.data['data'];

    return data
        .map((e) => ApplicationModel.fromJson(e))
        .toList();
  }

  // admin approve/reject
  Future<void> updateStatus(
  int id,
  String status, {
  String? reason,
  }) async {
    await api.patch(
      '/applications/$id',
      data: {
        'status': status,

        // 🔥 INI BAGIAN REASON
        if (reason != null && reason.isNotEmpty)
          'alasan': reason,
      },
    );
  }

  Future<List<ApplicationModel>>
      getMyApplications() async {

    final response = await api.get(
      '/my-applications',
    );

    final List data = response.data['data'];

    return data
        .map((e) => ApplicationModel.fromJson(e))
        .toList();
  }
}
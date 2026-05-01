import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class ApplicationProvider {
  final Dio _dio = ApiService().dio;

  // 🔥 APPLY KE OPPORTUNITY
  Future<Response> apply(int opportunityId, {String? alasan}) {
    return _dio.post(
      '/applications',
      data: {
        "opportunity_id": opportunityId,
        "alasan": alasan,
      },
    );
  }

  // 🔥 GET USER APPLICATIONS
  Future<Response> getMyApplications() {
    return _dio.get('/applications/my');
  }

  // 🔥 CEK SUDAH APPLY ATAU BELUM
  Future<Response> checkApplication(int opportunityId) {
    return _dio.get('/applications/check/$opportunityId');
  }
}

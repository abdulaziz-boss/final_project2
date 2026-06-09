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

  // admin lihat participants (SUDAH DENGAN PAGINATION)
  Future<Map<String, dynamic>> getParticipants(int opportunityId, {int page = 1}) async {
    final response = await api.get(
      '/applications/participants/$opportunityId',
      queryParameters: {'page': page}, // Kirim parameter ?page= ke Laravel
    );

    // Karena di Laravel kita mereturn ['data' => $participants], 
    // object pagination Laravel ada di dalam response.data['data']
    final paginateData = response.data['data'];

    // Kita ekstrak List datanya dan metadata paginationnya
    final List dataList = paginateData['data']; // Array item aslinya

    return {
      'items': dataList.map((e) => ApplicationModel.fromJson(e)).toList(),
      'total': paginateData['total'],
      'last_page': paginateData['last_page'],
    };
  }

  // admin approve/reject
  Future<void> updateStatus(
  int id,
  String status, {
  String? reason,
  }) async {
    await api.put(
      '/applications/$id/status',
      data: {
        'status': status,

        // 🔥 INI BAGIAN REASON
        if (reason != null && reason.isNotEmpty)
          'alasan': reason,
      },
    );
  }

  Future<List<ApplicationModel>> getMyApplications() async {
    try {
      final response = await api.get(
        '/applications/my-applications',
      );

      // 1. Validasi awal: Jika response atau response.data null, langsung kembalikan list kosong
      if (response.data == null || response.data['data'] == null) {
        return [];
      }

      // 2. Ambil payload 'data'
      final dynamic rawData = response.data['data'];
      
      List<dynamic> dataList;

      // 3. Antisipasi jika backend menggunakan pagination atau array biasa
      if (rawData is Map && rawData['data'] != null) {
        // Jika backend Laravel mereturn koleksi dengan ->paginate()
        dataList = rawData['data'];
      } else if (rawData is List) {
        // Jika backend mereturn array biasa menggunakan ->get()
        dataList = rawData;
      } else {
        return [];
      }

      // 4. Lakukan mapping ke model
      return dataList
          .map((e) => ApplicationModel.fromJson(e))
          .toList();
          
    } catch (e) {
      // Menjaga agar UI tidak freeze/crash jika backend bermasalah (404/500)
      print('Eror di getMyApplications: $e');
      return [];
    }
  }
}
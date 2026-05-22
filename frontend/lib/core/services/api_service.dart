import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../constants/api_constants.dart';
import 'storage_service.dart';

class ApiService {
  late Dio dio;
  final StorageService storage = StorageService();

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {

          final token = storage.getToken();

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) async {

          if (e.response?.statusCode == 401) {

            try {

              final oldToken = storage.getToken();

              // REQUEST REFRESH TOKEN
              final refreshResponse = await dio.post(
                '/refresh',
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $oldToken',
                  },
                ),
              );

              final newToken = refreshResponse.data['token'];

              // SIMPAN TOKEN BARU
              await storage.saveToken(newToken);

              // RETRY REQUEST LAMA
              final requestOptions = e.requestOptions;

              requestOptions.headers['Authorization'] =
                  'Bearer $newToken';

              final clonedResponse = await dio.fetch(requestOptions);

              return handler.resolve(clonedResponse);

            } catch (refreshError) {

              // kalau refresh gagal baru logout
              await storage.clearToken();

              Get.offAllNamed('/login');

              return handler.next(e);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }
}
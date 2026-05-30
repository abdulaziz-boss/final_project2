import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _startNavigationDelay();
  }

  void _startNavigationDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      final token = _storage.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;

      if (isLoggedIn) {
        Get.offAllNamed(Routes.main);
      } else {
        Get.offAllNamed(Routes.login);
      }
    });
  }
}

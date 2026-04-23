import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(StorageService(), permanent: true);
  }
}
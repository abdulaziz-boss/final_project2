import 'package:get/get.dart';
import '../../../data/repositories/application_repository.dart';

class ApplyController extends GetxController {
  final repo = ApplicationRepository();

  var isLoading = false.obs;

  Future<void> apply(int opportunityId) async {
    try {
      isLoading.value = true;

      await repo.apply(opportunityId);

      Get.snackbar("Success", "Berhasil daftar");
      Get.back();

    } catch (e) {
      Get.snackbar("Error", "Gagal daftar");
    } finally {
      isLoading.value = false;
    }
  }
}
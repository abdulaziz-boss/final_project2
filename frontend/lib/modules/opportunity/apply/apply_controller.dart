import 'package:get/get.dart';
import '../../../data/models/application_model.dart';
import '../../../data/repositories/application_repository.dart';

class ApplyController extends GetxController {
  final repo = ApplicationRepository();

  var isLoading = false.obs;
  var application = Rxn<ApplicationModel>();

  late final int opportunityId;

  @override
  void onInit() {
    opportunityId = Get.arguments as int;
    checkApplication();
    super.onInit();
  }

  // 🔥 CEK STATUS APPLY
  Future<void> checkApplication() async {
    try {
      isLoading.value = true;

      final result = await repo.check(opportunityId);
      application.value = result;
    } catch (e) {
      application.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 APPLY
  Future<void> apply() async {
    try {
      isLoading.value = true;

      await repo.apply(opportunityId);

      Get.snackbar("Success", "Berhasil daftar");

      await checkApplication();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
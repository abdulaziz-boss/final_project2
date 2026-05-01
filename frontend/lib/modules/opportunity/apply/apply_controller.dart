import 'package:get/get.dart';
import '../../../data/models/application_model.dart';
import '../../../data/repositories/application_repository.dart';

class ApplyController extends GetxController {
  final repo = ApplicationRepository();

  var isLoading = false.obs;
  var application = Rxn<ApplicationModel>(); // 🔥 null = belum apply

  late int opportunityId;

  @override
  void onInit() {
    opportunityId = Get.arguments;
    checkApplication();
    super.onInit();
  }

  // 🔥 CEK SUDAH APPLY
  Future<void> checkApplication() async {
    try {
      isLoading.value = true;

      final result = await repo.check(opportunityId);
      application.value = result;

    } catch (e) {
      print("ERROR CHECK APPLY: $e");
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

      // 🔥 refresh status setelah apply
      await checkApplication();

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
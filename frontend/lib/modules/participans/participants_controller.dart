import 'package:get/get.dart';

import '../../../data/models/application_model.dart';
import '../../../data/repositories/application_repository.dart';

class ParticipantsController extends GetxController {
  final repo = ApplicationRepository();

  var isLoading = false.obs;
  var participants = <ApplicationModel>[].obs;

  late final int opportunityId;

  @override
  void onInit() {
    opportunityId = Get.arguments as int;
    getParticipants();
    super.onInit();
  }

  Future<void> getParticipants() async {
    try {
      isLoading.value = true;

      final result = await repo.getParticipants(opportunityId);

      participants.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(
    int id,
    String status, {
    String? reason,
  }) async {
    try {
      await repo.updateStatus(
        id,
        status,
        reason: reason,
      );

      final index = participants.indexWhere((e) => e.id == id);

      if (index != -1) {
        participants[index] = participants[index].copyWith(
          status: status,
          alasan: reason ?? participants[index].alasan,
        );
        participants.refresh();
      }

      Get.snackbar("Success", "Status updated");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
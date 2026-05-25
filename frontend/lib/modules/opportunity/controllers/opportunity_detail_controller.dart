import 'package:get/get.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../data/models/application_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/providers/chat_provider.dart';
import '../../../data/repositories/application_repository.dart';

class OpportunityDetailController extends GetxController {
  // =========================
  // DATA
  // =========================
  late OpportunityModel data;

  // =========================
  // REPOSITORY
  // =========================
  final chatRepository = ChatRepository(ChatProvider());
  final applicationRepo = ApplicationRepository();

  // =========================
  // STATE
  // =========================
  var isLoading = false.obs;
  var application = Rxn<ApplicationModel>();

  late int opportunityId;

  @override
  void onInit() {
    super.onInit();

    data = Get.arguments;
    opportunityId = data.id;

    checkApplication();
  }

  // =========================
  // CHAT
  // =========================
  Future<void> startChat() async {
    try {
      if (data.organization == null) return;

      isLoading.value = true;

      final receiverId = data.organization!.userId;

      final conversation =
          await chatRepository.startConversation(receiverId);

      Get.toNamed('/chat', arguments: conversation.id);
    } catch (e) {
      Get.snackbar("Error", "Gagal memulai chat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // CHECK STATUS APPLY
  // =========================
  Future<void> checkApplication() async {
    try {
      isLoading.value = true;

      final result =
          await applicationRepo.check(opportunityId);

      application.value = result;
    } catch (e) {
      // kalau belum apply
      application.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // APPLY
  // =========================
  Future<void> apply() async {
    try {
      isLoading.value = true;

      await applicationRepo.apply(opportunityId);

      Get.snackbar(
        "Success",
        "Pendaftaran berhasil, menunggu verifikasi admin",
      );

      await checkApplication();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
import 'package:get/get.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/providers/chat_provider.dart';

class OpportunityDetailController extends GetxController {
  late OpportunityModel data;
  final chatRepository = ChatRepository(ChatProvider());
  final isLoading = false.obs;

  @override
  void onInit() {
    data = Get.arguments; // kirim dari card
    super.onInit();
  }

  Future<void> startChat() async {
    try {
      if (data.organization == null) return;
      
      isLoading.value = true;
      final receiverId = data.organization!.userId;
      
      final conversation = await chatRepository.startConversation(receiverId);
      
      Get.toNamed('/chat', arguments: conversation.id);
    } catch (e) {
      Get.snackbar("Error", "Gagal memulai chat: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
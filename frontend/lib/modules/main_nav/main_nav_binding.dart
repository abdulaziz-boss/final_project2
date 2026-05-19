import 'package:get/get.dart';
import 'main_nav_controller.dart';
import '../home/home_controller.dart';
import '../discover/discover_controller.dart';
import '../inbox/inbox_controller.dart';
import '../../data/providers/chat_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/repositories/notification_repository.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DiscoverController>(() => DiscoverController());

    // Inbox / Chat dependencies
    Get.lazyPut(() => ChatProvider());
    Get.lazyPut(() => ChatRepository(Get.find()));
    Get.lazyPut(() => NotificationProvider());
    Get.lazyPut(() => NotificationRepository(Get.find()));
    Get.lazyPut<InboxController>(() => InboxController(Get.find(), Get.find()));
  }
}
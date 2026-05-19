import 'package:get/get.dart';

import 'inbox_controller.dart';
import '../../data/providers/chat_provider.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/providers/notification_provider.dart';
import '../../data/repositories/notification_repository.dart';

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    // ChatProvider sudah menggunakan ApiService internal,
    // tidak perlu inject Dio secara manual
    Get.lazyPut(() => ChatProvider());
    Get.lazyPut(() => NotificationProvider());
    Get.lazyPut(() => NotificationRepository(Get.find()));

    Get.lazyPut(
      () => ChatRepository(Get.find()),
    );

    Get.lazyPut(
      () => InboxController(Get.find(), Get.find()),
    );
  }
}
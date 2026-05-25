import 'package:get/get.dart';
import 'participants_controller.dart';

class ParticipantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParticipantsController>(
      () => ParticipantsController(),
    );
  }
}
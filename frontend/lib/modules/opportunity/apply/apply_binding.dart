import 'package:get/get.dart';
import '../apply/apply_controller.dart';

class ApplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplyController());
  }
}
import 'package:get/get.dart';
import 'upgrade_controller.dart';

class UpgradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeController>(() => UpgradeController());
  }
}
import 'package:get/get.dart';
import '../profile/controllers/profile_controller.dart';

class MainNavController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    // Auto-refresh profile data whenever user taps Profile tab
    if (index == 3 && Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().getProfile();
    }
  }
}
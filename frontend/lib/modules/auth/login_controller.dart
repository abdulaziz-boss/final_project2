import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/services/google_auth_service.dart';


class LoginController extends GetxController {
  final AuthRepository repo = AuthRepository();

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final success = await repo.login(email, password);

    isLoading.value = false;

    if (success) {
      Get.offAllNamed('/main');
    } else {
      Get.snackbar("Error", "Login gagal");
    }
  }

  final GoogleAuthService googleService = GoogleAuthService();

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final idToken = await googleService.signIn();

      if (idToken == null) {
        isLoading.value = false;
        print("GOOGLE SIGN IN: User cancelled or failed to get idToken");
        return;
      }

      final success = await repo.loginWithGoogle(idToken);

      if (success) {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar("Error", "Login Google gagal");
      }
    } catch (e) {
      print("GOOGLE SIGN IN ERROR: $e");
      Get.snackbar("Error", "Terjadi kesalahan saat Login Google");
    } finally {
      isLoading.value = false;
    }
  }
}
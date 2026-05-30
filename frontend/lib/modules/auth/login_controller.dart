import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/services/google_auth_service.dart';

class LoginController extends GetxController {
  final AuthRepository repo = AuthRepository();
  final GoogleAuthService googleService = GoogleAuthService();

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;

  Future<void> login() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (emailC.text.trim().isEmpty ||
          passwordC.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Email dan password wajib diisi",
        );
        return;
      }

      isLoading.value = true;

      final success = await repo.login(
        emailC.text.trim(),
        passwordC.text.trim(),
      );

      if (success) {
        emailC.clear();
        passwordC.clear();

        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          "Error",
          "Login gagal",
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      String message = "Terjadi kesalahan";
      if (e is Exception) {
        message = e.toString().replaceFirst("Exception: ", "");
      } else {
        message = e.toString();
      }

      Get.snackbar(
        "Error",
        message,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final idToken = await googleService.signIn();

      if (idToken == null) return;

      final success = await repo.loginWithGoogle(idToken);

      if (success) {
        Get.offAllNamed('/main');
      } else {
        Get.snackbar(
          "Error",
          "Login Google gagal",
        );
      }
    } catch (e) {
      print("GOOGLE ERROR: $e");

      Get.snackbar(
        "Error",
        "Terjadi kesalahan",
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
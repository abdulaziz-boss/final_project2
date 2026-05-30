import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository repo = AuthRepository();

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;
  var isChecked = false.obs;

  Future<void> register() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (nameC.text.trim().isEmpty ||
          emailC.text.trim().isEmpty ||
          passwordC.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Semua field wajib diisi",
        );
        return;
      }

      if (!GetUtils.isEmail(emailC.text.trim())) {
        Get.snackbar(
          "Error",
          "Email tidak valid",
        );
        return;
      }

      if (passwordC.text.length < 6) {
        Get.snackbar(
          "Error",
          "Password minimal 6 karakter",
        );
        return;
      }

      isLoading.value = true;

      final success = await repo.register({
        "name": nameC.text.trim(),
        "email": emailC.text.trim(),
        "password": passwordC.text.trim(),
        "password_confirmation": passwordC.text.trim(),
        "role": "user",
      });

      if (success) {
        nameC.clear();
        emailC.clear();
        passwordC.clear();

        Get.snackbar(
          "Success",
          "Register berhasil",
        );

        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          "Error",
          "Register gagal",
        );
      }
    } catch (e) {
      print("REGISTER ERROR: $e");
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

  @override
  void onClose() {
    super.onClose();
  }
}
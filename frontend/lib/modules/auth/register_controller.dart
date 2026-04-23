import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterController extends GetxController {
  final AuthRepository repo = AuthRepository();

  // controller input
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isLoading = false.obs;

  Future<void> register() async {
    try {
      // VALIDASI BASIC
      if (nameC.text.isEmpty ||
          usernameC.text.isEmpty ||
          emailC.text.isEmpty ||
          passwordC.text.isEmpty) {
        Get.snackbar("Error", "Semua field wajib diisi");
        return;
      }

      if (!GetUtils.isEmail(emailC.text)) {
        Get.snackbar("Error", "Email tidak valid");
        return;
      }

      isLoading.value = true;

      final success = await repo.register({
        "name": nameC.text,
        "username": usernameC.text,
        "email": emailC.text,
        "password": passwordC.text,
        "password_confirmation": passwordC.text,
        "role": "user",
      });

      if (success) {
        Get.snackbar("Success", "Register berhasil");
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", "Register gagal");
      }

    } catch (e) {
      print("ERROR REGISTER: $e");
      Get.snackbar("Error", "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    usernameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
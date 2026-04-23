import 'package:get/get.dart';

class Validators {
  static String? email(String value) {
    if (value.isEmpty) return "Email wajib diisi";
    if (!GetUtils.isEmail(value)) return "Email tidak valid";
    return null;
  }

  static String? password(String value) {
    if (value.length < 6) return "Password minimal 6 karakter";
    return null;
  }

  static String? required(String value) {
    if (value.isEmpty) return "Field wajib diisi";
    return null;
  }
}
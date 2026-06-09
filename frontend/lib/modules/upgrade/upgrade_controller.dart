import 'dart:io';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/user_repository.dart';
import '../profile/controllers/profile_controller.dart';

class UpgradeController extends GetxController {
  var isLoading = false.obs;
  // Ditambahkan agar variabel ini bisa dibaca di View
  var isCurrentUser = true.obs; 
  final UserRepository userRepository = UserRepository();

  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final alamatController = TextEditingController();
  final websiteController = TextEditingController();

  var selectedLogo = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickLogo() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        selectedLogo.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar');
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    deskripsiController.dispose();
    alamatController.dispose();
    websiteController.dispose();
    super.onClose();
  }

  // Fungsi public untuk kirim data
  Future<void> requestUpgrade() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      String websiteText = websiteController.text.trim();
      if (websiteText.isNotEmpty && 
          !websiteText.startsWith('http://') && 
          !websiteText.startsWith('https://')) {
        websiteText = 'https://$websiteText';
      }

      final Map<String, dynamic> body = {
        'nama_organisasi': namaController.text.trim(),
        'deskripsi': deskripsiController.text.trim(),
      };

      final alamat = alamatController.text.trim();
      if (alamat.isNotEmpty) body['alamat'] = alamat;

      if (websiteText.isNotEmpty) body['website'] = websiteText;

      final formData = dio.FormData.fromMap(body);

      if (selectedLogo.value != null) {
        formData.files.add(MapEntry(
          'logo',
          await dio.MultipartFile.fromFile(
            selectedLogo.value!.path,
            filename: selectedLogo.value!.path.split('/').last,
          ),
        ));
      }

      final res = await userRepository.requestUpgrade(formData);
      if (res['success'] == true) {
        // Refresh data profil SEBELUM menutup halaman agar badge Pending langsung muncul
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().refreshFromMe();
        }
        Get.back();
        Get.snackbar(
          'Sukses',
          res['message'] ?? 'Permintaan upgrade berhasil dikirim',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Error', res['message'] ?? 'Gagal');
      }
    } on dio.DioException catch (e) {
      String msg = 'Gagal mengirim permintaan';
      if (e.response?.data != null && e.response!.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          msg = data['message'].toString();
          if (data['error'] != null) {
            msg += ": ${data['error']}";
          }
        } else if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            msg = errors.values.first[0].toString();
          }
        }
      }

      Get.snackbar(
        'Error',
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../data/repositories/user_repository.dart';
import '../../../../core/services/storage_service.dart';

class EditProfileController extends GetxController {
  final UserRepository userRepository = UserRepository();
  final StorageService storageService = StorageService();

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  final isLoading = false.obs;
  var profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  
  String? currentAvatarUrl;

  late int currentUserId;

  @override
  void onInit() {
    super.onInit();

    final user = Get.arguments;

    if (user != null) {
      currentUserId = user.id ?? 0;
      nameController.text = user.name ?? '';
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      bioController.text = user.bio ?? '';
      currentAvatarUrl = user.fotoProfilUrl;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;

      // Buat FormData untuk mengirim file dan data text
      final formData = dio.FormData.fromMap({
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'bio': bioController.text,
      });

      if (profileImage.value != null) {
        formData.files.add(MapEntry(
          'foto_profil',
          await dio.MultipartFile.fromFile(
            profileImage.value!.path,
            filename: profileImage.value!.path.split('/').last,
          ),
        ));
      }

      final updatedUser = await userRepository.updateProfile(currentUserId, formData);

      // Perbarui data user di local storage agar terupdate di seluruh aplikasi
      final currentUserData = await storageService.getUser();
      if (currentUserData != null) {
        currentUserData['name'] = updatedUser.name;
        currentUserData['username'] = updatedUser.username;
        currentUserData['email'] = updatedUser.email;
        currentUserData['foto_profil_url'] = updatedUser.fotoProfilUrl;
        currentUserData['foto_profil'] = updatedUser.fotoProfil;
        await storageService.saveUserData(
          token: await storageService.getToken() ?? '',
          role: currentUserData['role'],
          user: currentUserData,
        );
      }

      Get.back(result: true);

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/opportunity_model.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/services/storage_service.dart';
import 'package:frontend_final/modules/inbox/inbox_controller.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  final UserRepository userRepository = UserRepository();
  final AuthRepository authRepository = AuthRepository();
  final StorageService storageService = StorageService();

  var isLoading = false.obs;
  var isCurrentUser = true.obs;

  Rx<UserModel?> user = Rx<UserModel?>(null);
  var opportunities = <OpportunityModel>[].obs;

  int profileUserId = 0;

  @override
  void onInit() {
    super.onInit();
    initProfile();
  }

  Future<void> initProfile() async {
    final args = Get.arguments;

    if (args != null && args is int) {
      profileUserId = args;
      isCurrentUser.value = false;

      await getProfile();
    } else {
      await _loadCurrentUserId();
    }
  }

  Future<void> _loadCurrentUserId() async {
    final currentUserData = await storageService.getUser();

    print("CURRENT USER DATA: $currentUserData");

    if (currentUserData != null) {
      profileUserId = currentUserData['id'];
      isCurrentUser.value = true;

      print("PROFILE USER ID: $profileUserId");

      await getProfile();
    } else {
      print("USER DI STORAGE NULL");
      isLoading.value = false;
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      final data = await userRepository.getUserProfile(profileUserId);
      user.value = UserModel.fromJson(data['user']);

      if (data['opportunities'] != null) {
        opportunities.value = (data['opportunities'] as List)
            .map((e) => OpportunityModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data user saat ini dari /auth/me agar relasi organization ikut termuat
  Future<void> refreshFromMe() async {
    try {
      isLoading.value = true;
      final data = await authRepository.me();
      if (data != null) {
        user.value = UserModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('refreshFromMe error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void startChat() {
    if (isCurrentUser.value) return;
    if (Get.isRegistered<InboxController>()) {
      Get.find<InboxController>().startConversation(profileUserId);
    } else {
      Get.snackbar('Error', 'Modul pesan belum siap.');
    }
  }

  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin mau keluar?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await authRepository.logout();
    Get.offAllNamed('/login');
  }
}

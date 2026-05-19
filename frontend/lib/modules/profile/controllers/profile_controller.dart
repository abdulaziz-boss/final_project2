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
  var isFollowing = false.obs;
  var followersCount = 0.obs;
  var followingsCount = 0.obs;
  var isCurrentUser = true.obs;

  Rx<UserModel?> user = Rx<UserModel?>(null);
  var opportunities = <OpportunityModel>[].obs;

  int profileUserId = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is int) {
      profileUserId = args;
      isCurrentUser.value = false;
    } else {
      _loadCurrentUserId();
    }
    
    if (profileUserId != 0) {
      getProfile();
      if (!isCurrentUser.value) {
        checkFollowStatus();
      }
    }
  }

  Future<void> _loadCurrentUserId() async {
    final currentUserData = await storageService.getUser();
    if (currentUserData != null) {
      profileUserId = currentUserData['id'];
      getProfile();
    }
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      final data = await userRepository.getUserProfile(profileUserId);
      user.value = UserModel.fromJson(data['user']);
      followersCount.value = data['user']['followers_count'] ?? 0;
      followingsCount.value = data['user']['followings_count'] ?? 0;
      
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

  Future<void> toggleFollow() async {
    if (isCurrentUser.value) return;
    try {
      final res = await userRepository.toggleFollow(profileUserId);
      if (res['status'] == 'success') {
        isFollowing.value = res['is_following'];
        followersCount.value = res['followers_count'];
        followingsCount.value = res['followings_count'];
        Get.snackbar('Sukses', res['message'], backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses permintaan');
    }
  }

  Future<void> checkFollowStatus() async {
    if (isCurrentUser.value) return;
    try {
      final res = await userRepository.checkFollowStatus(profileUserId);
      if (res['status'] == 'success') {
        isFollowing.value = res['is_following'];
        followersCount.value = res['followers_count'];
        followingsCount.value = res['followings_count'];
      }
    } catch (e) {
      debugPrint('Check follow status error: $e');
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
    await authRepository.logout();
    Get.offAllNamed('/login');
  }

  void showUpgradeForm() {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController();
    final deskripsiController = TextEditingController();
    final alamatController = TextEditingController();
    final websiteController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upgrade ke Admin (Daftar Organisasi)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Organisasi'),
                  validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(labelText: 'Deskripsi Singkat'),
                  validator: (v) => v!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat (Opsional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: websiteController,
                  decoration: const InputDecoration(labelText: 'Website (Opsional)'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006C49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Get.back();
                        await _requestUpgrade({
                          'nama_organisasi': namaController.text,
                          'deskripsi': deskripsiController.text,
                          'alamat': alamatController.text,
                          'website': websiteController.text,
                        });
                      }
                    },
                    child: const Text('Kirim Permintaan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _requestUpgrade(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final res = await userRepository.requestUpgrade(data);
      if (res['success']) {
        Get.snackbar('Sukses', res['message'], backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', res['message'] ?? 'Gagal');
      }
    } on dio.DioException catch (e) {
      final msg = e.response?.data['message'] ?? 'Gagal mengirim permintaan';
      Get.snackbar('Error', msg, backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
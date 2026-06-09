import 'package:get/get.dart';
import 'package:flutter/material.dart'; 
import '../../../core/services/storage_service.dart';
import '../../../data/models/application_model.dart';
import '../../../data/repositories/application_repository.dart';

class ParticipantsController extends GetxController {
  final repo = ApplicationRepository();

  // State untuk Pagination & Data
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var participants = <ApplicationModel>[].obs;
  
  var totalParticipants = 0.obs;
  var currentPage = 1;
  var hasMore = true.obs;

  late final int opportunityId;
  var currentUserId = 0.obs;
  var opportunityCreatorId = 0.obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map) {
      opportunityId = args['id'];
      opportunityCreatorId.value = args['createdBy'] ?? 0;
    } else {
      opportunityId = args as int;
    }

    final userData = StorageService().getUserData();
    if (userData != null) {
      currentUserId.value = userData['id'] ?? 0;
    }

    print("ARGS = $args");
    print("CURRENT USER = ${currentUserId.value}");
    print("CREATOR = ${opportunityCreatorId.value}");

    getParticipants(isRefresh: true);
    super.onInit();
    
  }

  // Tambahkan parameter isRefresh untuk mereset pagination
  Future<void> getParticipants({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      participants.clear();
      isLoading.value = true;
    } else {
      if (!hasMore.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      // Panggil repo dengan menyertakan currentPage
      final result = await repo.getParticipants(opportunityId, page: currentPage);

      // Ekstrak data dari Map hasil kembalian repository
      final List<ApplicationModel> newItems = result['items'];
      totalParticipants.value = result['total'] ?? 0;
      
      // Cek apakah halaman saat ini sudah mencapai halaman terakhir
      if (currentPage >= (result['last_page'] ?? 1)) {
        hasMore.value = false;
      }

      if (newItems.isNotEmpty) {
        participants.addAll(newItems);
        currentPage++; // Tambah halaman untuk request berikutnya
      }
      
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data partisipan");
      print(e); // Untuk melihat error di console jika ada
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> updateStatus(
    int id,
    String status, {
    String? reason,
  }) async {
    try {
      await repo.updateStatus(
        id,
        status,
        reason: reason,
      );

      final index = participants.indexWhere((e) => e.id == id);

      if (index != -1) {
        participants[index] = participants[index].copyWith(
          status: status,
          alasan: reason ?? participants[index].alasan,
        );
        participants.refresh();
      }

      Get.snackbar(
        "Berhasil", 
        "Status partisipan diperbarui",
        backgroundColor: Color(0xFFDCFCE7), // Hapus 'const' di sini
        colorText: Color(0xFF047857),       // Hapus 'const' di sini
      );
    } catch (e) {
      Get.snackbar(
        "Error", 
        e.toString(), 
        backgroundColor: Color(0xFFFEE2E2), // Hapus 'const' di sini
        colorText: Color(0xFFB91C1C),       // Hapus 'const' di sini
      );
    }
  }
}
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_final/data/repositories/opportunity_repository.dart';
import 'package:frontend_final/modules/main_nav/main_nav_controller.dart';
import 'package:frontend_final/modules/home/home_controller.dart';

class CreatePostController extends GetxController {
  final OpportunityRepository opportunityRepository = OpportunityRepository();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final mapsUrlController = TextEditingController();
  final kuotaController = TextEditingController();

  final selectedType = 'offline'.obs; // offline or online
  final tanggalMulai = Rx<DateTime?>(null);
  final tanggalSelesai = Rx<DateTime?>(null);

  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);

  final selectedCategoryId = Rx<int?>(null);
  final categories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final list = await opportunityRepository.getCategories();
      categories.value = list;
    } catch (e) {
      debugPrint("ERROR FETCH CATEGORIES: $e");
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      if (isStart) {
        tanggalMulai.value = picked;
      } else {
        tanggalSelesai.value = picked;
      }
    }
  }

  Future<void> createPost() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedCategoryId.value == null) {
      Get.snackbar(
        'Validasi',
        'Silakan pilih kategori',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (tanggalMulai.value == null || tanggalSelesai.value == null) {
      Get.snackbar(
        'Validasi',
        'Silakan pilih tanggal mulai dan selesai',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      dio.FormData formData = dio.FormData.fromMap({
        'judul': titleController.text,
        'deskripsi': descriptionController.text,
        'lokasi': locationController.text,
        'maps_url': mapsUrlController.text,
        'tipe': selectedType.value,
        'tanggal_mulai': tanggalMulai.value!.toIso8601String().split('T').first,
        'tanggal_selesai': tanggalSelesai.value!.toIso8601String().split('T').first,
        'kuota': int.tryParse(kuotaController.text) ?? 10,
        'categories[]': selectedCategoryId.value,
      });

      if (selectedImage.value != null) {
        formData.files.add(MapEntry(
          'foto',
          await dio.MultipartFile.fromFile(
            selectedImage.value!.path,
            filename: selectedImage.value!.path.split('/').last,
          ),
        ));
      }

      await opportunityRepository.createOpportunity(formData);

      Get.snackbar(
        'Success',
        'Opportunity berhasil diposting',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Paksa kembali ke menu utama (Home tab) dan refresh seluruhnya
      Get.offAllNamed('/main');
    } on dio.DioException catch (e) {
      final msg = e.response?.data['message'] ?? e.response?.data['errors']?.toString() ?? 'Terjadi kesalahan';
      Get.snackbar(
        'Error',
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    mapsUrlController.dispose();
    kuotaController.dispose();
    super.onClose();
  }
}
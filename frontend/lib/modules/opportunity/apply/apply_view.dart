import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apply_controller.dart';

class ApplyView extends GetView<ApplyController> {
  const ApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    final int id = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Volunteer")),
      body: Center(
        child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.apply(id),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text("Kirim Pendaftaran"),
            )),
      ),
    );
  }
}
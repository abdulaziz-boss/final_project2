import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apply_controller.dart';

class ApplyView extends GetView<ApplyController> {
  const ApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFC),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Text(
          'Daftar Volunteer',
          style: TextStyle(
            color: Color(0xFF047857),
            fontSize: 18,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Obx(() {
          // 🔄 loading
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }

          final app = controller.application.value;

          // ❌ BELUM APPLY
          if (app == null) {
            return ElevatedButton(
              onPressed: controller.apply,
              child: const Text("Daftar Sekarang"),
            );
          }

          // 🔥 SUDAH APPLY → tampilkan status
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Status: ${app.status.toUpperCase()}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (app.status == 'pending')
                const Text("⏳ Menunggu persetujuan"),

              if (app.status == 'accepted')
                const Text("✅ Kamu diterima!"),

              if (app.status == 'rejected')
                const Text("❌ Pendaftaran ditolak"),
            ],
          );
        }),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/opportunity_detail_controller.dart';

class OpportunityDetailView extends GetView<OpportunityDetailController> {
  const OpportunityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kegiatan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            if (data.foto != null && data.foto!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data.foto!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),

            // JUDUL
            Text(
              data.judul,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // INFO
            Text("📍 ${data.lokasi}"),
            Text("🗓 ${data.tanggalMulai}"),
            Text("👥 Kuota: ${data.kuota}"),
            Text("🌐 ${data.tipe}"),

            const SizedBox(height: 16),

            // DESKRIPSI
            Text(
              data.deskripsi,
              style: const TextStyle(height: 1.5),
            ),

            const SizedBox(height: 24),

            // BUTTON APPLY
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: data.status == 'open'
                    ? () {
                        Get.toNamed('/apply', arguments: data.id);
                      }
                    : null,
                child: Text(
                  data.status == 'open'
                      ? "Daftar Sekarang"
                      : "Pendaftaran Ditutup",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
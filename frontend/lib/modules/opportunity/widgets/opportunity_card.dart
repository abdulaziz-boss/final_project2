import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/opportunity_model.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel data;

  const OpportunityCard({super.key, required this.data});

  Future<void> _openMap() async {
    final url = data.mapsUrl ?? '';
    if (url.isEmpty) return;

    final uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar("Error", "Gagal membuka lokasi");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipe = data.tipe == 'online' ? 'Online' : 'Offline';
    final isActive = data.mapsUrl != null && data.mapsUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Get.toNamed('/opportunity-detail', arguments: data);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TITLE
            Text(
              data.judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            // 🔥 DESKRIPSI
            Text(
              data.deskripsi,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // 🔥 LOKASI (CLICKABLE)
            GestureDetector(
              onTap: isActive ? _openMap : null,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: isActive ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data.lokasi,
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        decoration: isActive
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            Text("🗓 ${data.tanggalMulai}"),
            Text("👥 Kuota: ${data.kuota}"),
            Text("🌐 $tipe"),

            const SizedBox(height: 12),

            // 🔥 STATUS + APPLY BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.status == 'open'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: data.status == 'open'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: data.status == 'open'
                      ? () {
                          Get.toNamed('/apply', arguments: data.id);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    data.status == 'open'
                        ? "Daftar"
                        : "Ditutup",
                  ),
                ),
              ],
            ),

            if (isActive)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "📌 Lokasi tersedia",
                  style: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/opportunity_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/like/like_widget.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel data;
  final String? applyStatus;

  const OpportunityCard({super.key, required this.data, this.applyStatus});

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
    final orgName = data.organization?.namaOrganisasi ?? "Penyelenggara";

    String avatarUrl = 'https://ui-avatars.com/api/?name=$orgName&background=random';
    if (data.organization?.logo != null) {
      final logo = data.organization!.logo!;
      avatarUrl = logo.startsWith('http') 
          ? logo 
          : '${ApiConstants.storageUrl}/$logo';
    }

    String? bannerUrl;
    if (data.foto != null) {
      bannerUrl = data.foto!.startsWith('http') 
          ? data.foto 
          : '${ApiConstants.storageUrl}/${data.foto}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 IG HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[100],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orgName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      if (data.lokasi.isNotEmpty)
                        GestureDetector(
                          onTap: isActive ? _openMap : null,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 12,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  data.lokasi,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔥 IG IMAGE
          if (bannerUrl != null)
            GestureDetector(
              onTap: () => Get.toNamed('/opportunityDetail', arguments: data),
              child: CachedNetworkImage(
                imageUrl: bannerUrl,
                width: double.infinity,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
              ),
            ),

          // 🔥 CTA BUTTON (Instagram Ad Style)
          if (data.status == 'open' && applyStatus == null)
            InkWell(
              onTap: () => Get.toNamed('/apply', arguments: data.id),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: const Color(0xFF006C49), // Warna primer
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),

          // 🔥 IG ACTIONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                LikeWidget(opportunityId: data.id),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline, size: 24),
                const SizedBox(width: 16),
                const Icon(Icons.send_outlined, size: 24),
                const Spacer(),
                const Icon(Icons.bookmark_border, size: 26),
              ],
            ),
          ),

          // 🔥 IG CAPTION & DETAILS
          GestureDetector(
            onTap: () => Get.toNamed('/opportunityDetail', arguments: data),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "1,234 likes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(
                          text: "$orgName ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "${data.judul}. ",
                        ),
                        TextSpan(
                          text: data.deskripsi,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Extra Info (Instagram Style)
                  Row(
                    children: [
                      Text(
                        "🗓 ${data.tanggalMulai}",
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "👥 ${data.kuota} Kuota",
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "🌐 $tipe",
                        style: TextStyle(color: Colors.grey[500], fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "View all 12 comments",
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "2 hours ago",
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
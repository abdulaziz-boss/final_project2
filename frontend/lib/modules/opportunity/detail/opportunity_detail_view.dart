import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/opportunity_detail_controller.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/like/like_widget.dart';
import '../../shared/comment/comment_widget.dart';
import '../../shared/comment/comment_input.dart';

class OpportunityDetailView extends GetView<OpportunityDetailController> {
  const OpportunityDetailView({super.key});

  Future<void> _openMap(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar("Error", "Gagal membuka lokasi di Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.data;
    final orgName = data.organization?.namaOrganisasi ?? "Penyelenggara";
    final hasMap = data.mapsUrl != null && data.mapsUrl!.isNotEmpty;
    
    String? imageUrl;
    if (data.foto != null && data.foto!.isNotEmpty) {
      imageUrl = data.foto!.startsWith('http') 
          ? data.foto 
          : '${ApiConstants.storageUrl}/${data.foto}';
    }

    String avatarUrl = 'https://ui-avatars.com/api/?name=$orgName&background=random';
    if (data.organization?.logo != null) {
      final logo = data.organization!.logo!;
      avatarUrl = logo.startsWith('http') 
          ? logo 
          : '${ApiConstants.storageUrl}/$logo';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 🔥 HEADER WITH IMAGE
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF006C49),
            flexibleSpace: FlexibleSpaceBar(
              background: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[200]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF006C49),
                      child: const Icon(Icons.volunteer_activism, size: 80, color: Colors.white70),
                    ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔥 STATUS BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: data.status == 'open' ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: data.status == 'open' ? const Color(0xFF166534) : const Color(0xFF991B1B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🔥 TITLE
                  Text(
                    data.judul,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🔥 ORGANIZATION INFO
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: avatarUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orgName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Text(
                                "Penyelenggara Terverifikasi",
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🔥 LIKE WIDGET
                  LikeWidget(opportunityId: data.id),
                  const SizedBox(height: 32),

                  // 🔥 DETAILS GRID
                  const Text(
                    "Informasi Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  // 🔥 LOKASI (CLICKABLE)
                  _buildDetailRow(
                    Icons.location_on_outlined, 
                    "Lokasi", 
                    data.lokasi,
                    onTap: hasMap ? () => _openMap(data.mapsUrl) : null,
                    isLink: hasMap,
                  ),
                  
                  _buildDetailRow(Icons.calendar_today_outlined, "Tanggal Mulai", data.tanggalMulai),
                  _buildDetailRow(Icons.people_outline, "Kuota", "${data.kuota} Orang"),
                  _buildDetailRow(Icons.language_outlined, "Tipe", data.tipe.toUpperCase()),
                  
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // 🔥 DESCRIPTION
                  const Text(
                    "Tentang Kegiatan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.deskripsi,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: Color(0xFF475569),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 32),

                  // 🔥 COMMENT SECTION
                  const Text(
                    "Komentar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CommentWidget(opportunityId: data.id),
                  const SizedBox(height: 12),
                  CommentInput(opportunityId: data.id),

                  const SizedBox(height: 120), // Spacer for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ElevatedButton(
          onPressed: data.status == 'open' 
              ? () => Get.toNamed('/apply', arguments: data.id)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006C49),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Text(
            data.status == 'open' ? "Daftar Sekarang" : "Pendaftaran Ditutup",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {VoidCallback? onTap, bool isLink = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLink ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: isLink ? const Color(0xFF006C49) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  Text(
                    value, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 15, 
                      color: isLink ? const Color(0xFF006C49) : const Color(0xFF1E293B),
                      decoration: isLink ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
            if (isLink)
              const Icon(Icons.open_in_new, size: 16, color: Color(0xFF006C49)),
          ],
        ),
      ),
    );
  }
}
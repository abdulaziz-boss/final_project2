import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/opportunity_detail_controller.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/like/like_widget.dart';
import '../../shared/comment/comment_widget.dart';
import '../../shared/comment/comment_input.dart';
import '../../opportunity/controllers/opportunity_controller.dart';

class OpportunityDetailView extends GetView<OpportunityDetailController> {
  const OpportunityDetailView({super.key});

  Future<void> _openMap(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar("Error", "Gagal membuka lokasi di Google Maps",
          backgroundColor: Colors.red.shade100, colorText: Colors.red.shade900);
    }
  }

  // 🔥 ACTION TEXT
  String getActionText(data, OpportunityController opportunityController) {
    if (data.status != 'open') {
      return "Pendaftaran Ditutup";
    }

    if (opportunityController.userRole.value == 'admin') {
      return "Lihat Partisipan";
    }

    return "Daftar Sekarang";
  }

  // 🔥 ACTION HANDLER
  void handleAction(data, opportunityController) {
    if (data.status != 'open') {
      Get.snackbar("Info", "Pendaftaran sudah ditutup",
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900);
      return;
    }

    if (opportunityController.userRole.value == 'admin') {
      Get.toNamed('/participants', arguments: {
        'id': data.id,
        'createdBy': data.createdBy,
      });
      return;
    }

    final app = controller.application.value;

    if (app != null) {
      Get.toNamed('/apply', arguments: data.id);
      return;
    }

    controller.apply();
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.data;
    final orgName = data.organization?.namaOrganisasi ?? "Penyelenggara";
    final hasMap = data.mapsUrl != null && data.mapsUrl!.isNotEmpty;
    final opportunityController = Get.find<OpportunityController>();

    // Definisi Palet Warna
    const Color primaryGreen = Color(0xFF006C49);
    const Color lightGreen = Color(0xFFE8F5E9); // Hijau sangat muda
    const Color textDark = Color(0xFF1E293B);
    const Color textGrey = Color(0xFF64748B);

    String? imageUrl;
    if (data.foto != null && data.foto!.isNotEmpty) {
      imageUrl = data.foto!.startsWith('http')
          ? data.foto
          : '${ApiConstants.storageUrl}/${data.foto}';
    }

    String avatarUrl =
        'https://ui-avatars.com/api/?name=$orgName&background=006C49&color=fff'; // Sesuaikan avatar placeholder dengan tema

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
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: primaryGreen,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Utama
                  imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: primaryGreen,
                          child: const Icon(
                            Icons.volunteer_activism,
                            size: 80,
                            color: Colors.white70,
                          ),
                        ),
                  // Gradien agar panah back selalu terlihat
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.black12,
                        ],
                        stops: [0.0, 0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STATUS
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: data.status == 'open'
                                ? lightGreen
                                : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: data.status == 'open'
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data.status == 'open'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                size: 16,
                                color: data.status == 'open'
                                    ? primaryGreen
                                    : const Color(0xFF991B1B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                data.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: data.status == 'open'
                                      ? primaryGreen
                                      : const Color(0xFF991B1B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        LikeWidget(opportunityId: data.id),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // TITLE
                    Text(
                      data.judul,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ORGANIZATION CARD (Dipercantik)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.green.shade100, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  CachedNetworkImageProvider(avatarUrl),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orgName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textDark,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.verified_user,
                                        size: 14, color: Colors.green.shade600),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "Penyelenggara",
                                      style: TextStyle(
                                          color: textGrey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // INFORMASI KEGIATAN
                    const Text(
                      "Informasi Kegiatan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: lightGreen.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.location_on_rounded, "Lokasi",
                              data.lokasi,
                              onTap: hasMap ? () => _openMap(data.mapsUrl) : null,
                              isLink: hasMap,
                              primaryGreen: primaryGreen,
                              textDark: textDark,
                              textGrey: textGrey),
                          _buildDetailRow(Icons.calendar_month_rounded,
                              "Tanggal Mulai", data.tanggalMulai,
                              primaryGreen: primaryGreen,
                              textDark: textDark,
                              textGrey: textGrey),
                          _buildDetailRow(Icons.people_alt_rounded, "Kuota",
                              "${data.kuota} Orang",
                              primaryGreen: primaryGreen,
                              textDark: textDark,
                              textGrey: textGrey),
                          _buildDetailRow(Icons.category_rounded, "Tipe",
                              data.tipe.toUpperCase(),
                              primaryGreen: primaryGreen,
                              textDark: textDark,
                              textGrey: textGrey,
                              isLast: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // TENTANG KEGIATAN
                    const Text(
                      "Tentang Kegiatan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data.deskripsi,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF475569), // Slate 600
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFE2E8F0)), // Batas halus
                    const SizedBox(height: 24),

                    // KOMENTAR
                    const Text(
                      "Komentar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🔥 FIX OVERFLOW TANPA UBAH UI
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 200,
                        maxHeight: 500,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Column(
                        children: [
                          // LIST COMMENT
                          Expanded(
                            child: CommentWidget(
                              opportunityId: data.id,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // INPUT COMMENT
                          CommentInput(
                            opportunityId: data.id,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // 🔥 BOTTOM BUTTON (Floating dengan Shadow)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Tombol Chat
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryGreen.withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () => controller.startChat(),
                  icon: Icon(Icons.chat_rounded, color: primaryGreen),
                ),
              ),
              const SizedBox(width: 16),
              // Tombol Aksi Utama
              Expanded(
                child: ElevatedButton(
                  onPressed: data.status == 'open'
                      ? () => handleAction(data, opportunityController)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: data.status == 'open' ? 4 : 0,
                    shadowColor: primaryGreen.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    return Text(
                      getActionText(data, opportunityController),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: data.status == 'open'
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Refactor _buildDetailRow untuk tema Hijau Putih
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
    bool isLink = false,
    bool isLast = false,
    required Color primaryGreen,
    required Color textDark,
    required Color textGrey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Icon(icon, color: primaryGreen, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 2), // Vertical alignment tweak
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isLink ? primaryGreen : textDark,
                            decoration:
                                isLink ? TextDecoration.underline : null,
                          ),
                        ),
                      ),
                      if (isLink)
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: primaryGreen,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
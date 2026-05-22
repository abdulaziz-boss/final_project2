import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../inbox/inbox_controller.dart';
import '../../../data/models/opportunity_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/like/like_widget.dart';
import '../../shared/comment/comment_widget.dart';
import '../../shared/comment/comment_input.dart';
import '../../shared/comment/comment_count_widget.dart';
import '../controllers/opportunity_controller.dart';

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

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Komentar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: CommentWidget(opportunityId: data.id),
                  ),
                ),
              ),
              CommentInput(opportunityId: data.id),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tipe = data.tipe == 'online' ? 'Online' : 'Offline';
    final isActive = data.mapsUrl != null && data.mapsUrl!.isNotEmpty;
    final posterName = data.creator?.name ?? data.organization?.namaOrganisasi ?? "Penyelenggara";
    final opportunityController = Get.find<OpportunityController>();

    String avatarUrl =
        'https://ui-avatars.com/api/?name=$posterName&background=random';
    if (data.creator?.fotoProfilUrl != null && data.creator!.fotoProfilUrl!.isNotEmpty) {
      avatarUrl = data.creator!.fotoProfilUrl!;
    } else if (data.organization?.logo != null) {
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
                        posterName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      if (data.organization?.namaOrganisasi != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          data.organization!.namaOrganisasi,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black.withOpacity(0.55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),

          // 🔥 IG ACTIONS (Like, Comment, Share, Apply, Bookmark)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                LikeWidget(opportunityId: data.id),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showCommentSheet(context),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 24),
                      CommentCountWidget(
                        opportunityId: data.id,
                        initialCount: data.commentsCount,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    Get.find<InboxController>().showShareSheet(data);
                  },
                  child: const Icon(Icons.send_outlined, size: 24),
                ),
                const Spacer(),
                if (data.status == 'open' && applyStatus == null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextButton(
                      onPressed: () {
                        if (opportunityController.userRole.value == 'admin') {
                          Get.toNamed(
                            '/participants',
                            arguments: data.id,
                          );
                        } else {
                          Get.toNamed(
                            '/apply',
                            arguments: data.id,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF006C49),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Obx(() => Text(
                        opportunityController.userRole.value == 'admin'
                            ? 'Lihat Partisipan'
                            : 'Daftar Sekarang',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
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
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: [
                        TextSpan(
                          text: "$posterName ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: "${data.judul}. "),
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
                  
                  // 🔥 IG "View all X comments"
                  GestureDetector(
                    onTap: () => _showCommentSheet(context),
                    child: CommentCountWidget(
                      opportunityId: data.id,
                      initialCount: data.commentsCount,
                      isTextFormat: true,
                    ),
                  ),
                  
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

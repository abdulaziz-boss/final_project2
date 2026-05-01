import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentWidget extends StatelessWidget {
  final int opportunityId;

  const CommentWidget({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    final tag = 'comment_$opportunityId';

    if (!Get.isRegistered<CommentController>(tag: tag)) {
      Get.put(CommentController(opportunityId), tag: tag);
    }

    final controller = Get.find<CommentController>(tag: tag);

    return Obx(() {
      if (controller.isLoading.value && controller.comments.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }

      if (controller.comments.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Belum ada komentar. Jadilah yang pertama!",
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        );
      }

      return Column(
        children: [
          // Daftar Komentar
          ...controller.comments.map((c) => _buildCommentTile(c)),

          // Load More Button
          if (controller.hasMore)
            TextButton(
              onPressed: () => controller.loadMore(),
              child: Obx(() => controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      "Muat lebih banyak...",
                      style: TextStyle(color: Color(0xFF006C49)),
                    )),
            ),
        ],
      );
    });
  }

  Widget _buildCommentTile(dynamic comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFE2E8F0),
            child: Text(
              (comment.user.name.isNotEmpty ? comment.user.name[0] : '?').toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF475569),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 13),
                    children: [
                      TextSpan(
                        text: comment.user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(text: comment.comment),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _timeAgo(comment.createdAt),
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}h lalu';
    if (diff.inHours > 0) return '${diff.inHours}j lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m lalu';
    return 'Baru saja';
  }
}
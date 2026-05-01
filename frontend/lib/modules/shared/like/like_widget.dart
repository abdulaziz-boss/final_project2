import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'like_controller.dart';

class LikeWidget extends StatelessWidget {
  final int opportunityId;

  const LikeWidget({super.key, required this.opportunityId});

  @override
  Widget build(BuildContext context) {
    // Buat controller unik per opportunity agar tidak bentrok
    final tag = 'like_$opportunityId';

    // Register controller jika belum ada
    if (!Get.isRegistered<LikeController>(tag: tag)) {
      Get.put(LikeController(opportunityId), tag: tag);
    }

    final controller = Get.find<LikeController>(tag: tag);

    return Obx(() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => controller.toggleLike(),
              child: Icon(
                controller.isLiked.value ? Icons.favorite : Icons.favorite_border,
                color: controller.isLiked.value ? Colors.red : Colors.black,
                size: 26,
              ),
            ),
            if (controller.totalLikes.value > 0) ...[
              const SizedBox(width: 6),
              Text(
                '${controller.totalLikes.value}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ));
  }
}
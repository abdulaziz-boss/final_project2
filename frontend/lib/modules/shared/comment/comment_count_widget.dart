import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentCountWidget extends StatelessWidget {
  final int opportunityId;
  final int initialCount;

  const CommentCountWidget({
    super.key,
    required this.opportunityId,
    required this.initialCount,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'comment_$opportunityId';

    // Pastikan controller sudah ada
    if (!Get.isRegistered<CommentController>(tag: tag)) {
      final controller = Get.put(CommentController(opportunityId), tag: tag);
      // Set nilai awal dari model agar tidak 0 saat pertama muncul
      controller.totalComments.value = initialCount;
    }

    final controller = Get.find<CommentController>(tag: tag);

    return Obx(() {
      if (controller.totalComments.value <= 0) return const SizedBox.shrink();
      
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Text(
          "${controller.totalComments.value}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      );
    });
  }
}

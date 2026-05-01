import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentInput extends StatelessWidget {
  final int opportunityId;

  CommentInput({super.key, required this.opportunityId});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tag = 'comment_$opportunityId';

    // Pastikan controller sudah di-register oleh CommentWidget
    if (!Get.isRegistered<CommentController>(tag: tag)) {
      Get.put(CommentController(opportunityId), tag: tag);
    }

    final controller = Get.find<CommentController>(tag: tag);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tulis komentar...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF006C49)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => IconButton(
                onPressed: controller.isSending.value
                    ? null
                    : () {
                        controller.sendComment(_textController.text);
                        _textController.clear();
                      },
                icon: controller.isSending.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send, color: Color(0xFF006C49)),
              )),
        ],
      ),
    );
  }
}
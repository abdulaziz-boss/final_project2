import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'comment_controller.dart';

class CommentInput extends StatefulWidget {
  final int opportunityId;

  const CommentInput({
    super.key,
    required this.opportunityId,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();

    final tag = 'comment_${widget.opportunityId}';

    // register controller kalau belum ada
    if (!Get.isRegistered<CommentController>(tag: tag)) {
      Get.put(
        CommentController(widget.opportunityId),
        tag: tag,
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tag = 'comment_${widget.opportunityId}';

    final controller = Get.find<CommentController>(tag: tag);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.send,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Tulis komentar...",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Color(0xFF006C49),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
                onSubmitted: (_) async {
                  final text = _textController.text.trim();

                  if (text.isEmpty) return;

                  await controller.sendComment(text);

                  if (mounted) {
                    _textController.clear();
                  }
                },
              ),
            ),

            const SizedBox(width: 8),

            Obx(
              () => IconButton(
                onPressed: controller.isSending.value
                    ? null
                    : () async {
                        final text =
                            _textController.text.trim();

                        if (text.isEmpty) return;

                        await controller.sendComment(text);

                        if (mounted) {
                          _textController.clear();
                        }
                      },
                icon: controller.isSending.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Color(0xFF006C49),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
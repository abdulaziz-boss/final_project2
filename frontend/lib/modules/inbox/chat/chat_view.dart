import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../inbox_controller.dart';
import '../widgets/message_bubble.dart';

class ChatView extends StatefulWidget {
  final int conversationId;

  const ChatView({
    super.key,
    required this.conversationId,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = Get.find<InboxController>();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.getMessages(widget.conversationId);

    controller.startChatPolling(widget.conversationId);
  }

  @override
  void dispose() {
    controller.stopChatPolling();

    scrollController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatMessageTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFC),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF191C1D)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Obrolan',
          style: TextStyle(
            color: Color(0xFF191C1D),
            fontSize: 18,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFF0F3F7),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // ===== MESSAGE LIST =====
          Expanded(
            child: Obx(() {
              // Jika sedang loading awal dan data masih kosong
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF047857)),
                );
              }

              // Jika data kosong
              if (controller.messages.isEmpty) {
                return _buildEmptyState();
              }

              // Auto scroll ke bawah (gunakan PostFrameCallback di luar builder jika memungkinkan, 
              // tapi untuk list chat sederhana ini masih oke selama tidak memicu state change baru)
              Future.microtask(() => _scrollToBottom());

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  final isMe = msg.senderId == controller.currentUserId;

                  return MessageBubble(
                    message: msg.message,
                    isMe: isMe,
                    time: _formatMessageTime(msg.createdAt),
                  );
                },
              );
            }),
          ),

          // ===== INPUT BAR =====
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Belum ada pesan',
            style: TextStyle(color: Color(0xFF6C7A71), fontSize: 16),
          ),
          const Text(
            'Mulai percakapan sekarang!',
            style: TextStyle(color: Color(0xFF8C8D8E), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F3F7))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  filled: true,
                  fillColor: const Color(0xFFF3F4F5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF047857),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => controller.sendMessage(widget.conversationId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
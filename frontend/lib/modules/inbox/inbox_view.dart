import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'inbox_controller.dart';
import 'widgets/conversation_tile.dart';

class Inboxpage extends GetView<InboxController> {
  const Inboxpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER (Sticky) =====
            _buildHeader(),

            // ===== BODY (Scrollable) =====
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TAB SWITCHER =====
                    _buildTabSwitcher(),
                    const SizedBox(height: 24),

                    // ===== CONTENT BASED ON TAB =====
                    Obx(() {
                      if (controller.selectedTab.value == 0) {
                        return _buildPesanTab();
                      } else {
                        return _buildAktivitasTab();
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF9FBFC),
        border: Border(bottom: BorderSide(color: Color(0xFFF0F3F7))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: const Row(
        children: [
          Icon(Icons.volunteer_activism, color: Color(0xFF047857), size: 28),
          SizedBox(width: 8),
          Text(
            'ZAKKAL.APL',
            style: TextStyle(
              color: Color(0xFF047857),
              fontSize: 20,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Obx(() => Container(
          width: double.infinity,
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: ShapeDecoration(
            color: const Color(0xFFF3F4F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          child: Row(
            children: [
              _buildTabButton(0, 'Pesan', controller.unreadMessagesCount > 0, controller.unreadMessagesCount),
              _buildTabButton(1, 'Aktivitas', controller.unreadNotificationsCount > 0, controller.unreadNotificationsCount),
            ],
          ),
        ));
  }

  Widget _buildTabButton(int index, String label, bool showBadge, int badgeCount) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          decoration: ShapeDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF006C49) : const Color(0xFF3C4A42),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                if (showBadge) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPesanTab() {
    return Column(
      children: [
        // Search Bar (Outside of reactive list to prevent focus loss)
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF6C7A71), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: const InputDecoration(
                    hintText: 'Cari percakapan...',
                    hintStyle: TextStyle(color: Color(0xFF8C8D8E), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Reactive List
        Obx(() {
          if (controller.isLoading.value && controller.conversations.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Color(0xFF047857)),
              ),
            );
          }

          final list = controller.filteredConversations;
          if (list.isEmpty) return _buildEmptyState('Belum ada percakapan');

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final conversation = list[index];
              return ConversationTile(
                name: controller.getOtherUserName(conversation),
                lastMessage: conversation.lastMessage ?? '',
                time: _formatTime(conversation.lastMessageTime),
                photoUrl: controller.getOtherUserPhoto(conversation),
                unreadCount: conversation.unreadCount,
                onTap: () => Get.toNamed('/chat', arguments: conversation.id),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildAktivitasTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aktivitas Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF0051D5)),
              onPressed: () => controller.getNotifications(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.notifications.isEmpty) {
            return _buildEmptyState('Belum ada aktivitas baru');
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              return _buildAktivitasItem(
                judul: notif.judul,
                desc: notif.isi,
                time: _formatTime(notif.createdAt),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Color(0xFF6C7A71), fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildAktivitasItem({required String judul, required String desc, required String time}) {
    IconData icon = Icons.notifications;
    Color iconColor = const Color(0xFF047857);
    Color bgColor = const Color(0xFFDCFCE7);

    if (judul.toLowerCase().contains('like')) {
      icon = Icons.favorite;
      iconColor = const Color(0xFFB91C1C);
      bgColor = const Color(0xFFFEE2E2);
    } else if (judul.toLowerCase().contains('komen')) {
      icon = Icons.comment;
      iconColor = const Color(0xFF1D4ED8);
      bgColor = const Color(0xFFDBEAFE);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            radius: 20,
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: const TextStyle(fontSize: 14, color: Color(0xFF191C1D))),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Color(0xFF6C7A71), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 1) return 'Baru saja';
      if (diff.inHours < 1) return '${diff.inMinutes}m lalu';
      if (diff.inDays < 1) return '${diff.inHours}j lalu';
      if (diff.inDays == 1) return 'Kemarin';
      return '${date.day}/${date.month}';
    } catch (_) {
      return '';
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../data/models/conversation_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/models/opportunity_model.dart';
import '../../data/repositories/chat_repository.dart';
import '../../core/services/storage_service.dart';
import '../../data/repositories/notification_repository.dart';

class InboxController extends GetxController {
  final ChatRepository repository;
  final NotificationRepository notificationRepo;
  final StorageService storage = StorageService();

  // State
  var selectedTab = 0.obs; // 0: Pesan, 1: Aktivitas
  var isLoading = false.obs;
  var conversations = <ConversationModel>[].obs;
  var messages = <MessageModel>[].obs;
  var notifications = <NotificationModel>[].obs;
  var searchQuery = ''.obs;

  // Form
  final messageController = TextEditingController();
  int currentUserId = 0;

  InboxController(this.repository, this.notificationRepo);

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserId();
    getConversations();
    getNotifications();
  }

  Future<void> _loadCurrentUserId() async {
    final user = await storage.getUser();
    if (user != null) {
      currentUserId = user['id'] ?? 0;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    if (index == 0) {
      getConversations();
    } else {
      getNotifications();
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  List<ConversationModel> get filteredConversations {
    if (searchQuery.isEmpty) return conversations;
    return conversations.where((c) {
      final name = getOtherUserName(c).toLowerCase();
      return name.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  Future<void> getConversations() async {
    try {
      isLoading.value = true;
      final result = await repository.getConversations();
      conversations.assignAll(result);
    } catch (e) {
      debugPrint('ERROR INBOX: $e');
      _handleApiError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMessages(int conversationId) async {
    try {
      isLoading.value = true;
      final result = await repository.getMessages(conversationId);
      messages.assignAll(result);
    } catch (e) {
      debugPrint('ERROR MESSAGES: $e');
      _handleApiError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(int conversationId, {String? text}) async {
    final messageText = text ?? messageController.text;
    if (messageText.isEmpty) return;

    if (text == null) messageController.clear();

    try {
      await repository.sendMessage(
        conversationId: conversationId,
        message: messageText,
      );
      if (Get.currentRoute == '/chat') {
        getMessages(conversationId);
      }
    } catch (e) {
      debugPrint('ERROR SEND MESSAGE: $e');
      _handleApiError(e);
    }
  }

  Future<void> startConversation(int receiverId) async {
    if (receiverId == currentUserId) {
      Get.snackbar('Info', 'Anda tidak bisa mengirim pesan ke diri sendiri');
      return;
    }

    try {
      isLoading.value = true;
      final conversation = await repository.startConversation(receiverId);
      Get.toNamed('/chat', arguments: conversation.id);
    } catch (e) {
      debugPrint('ERROR START CONVERSATION: $e');
      _handleApiError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 🔥 SHARE FEATURE (TikTok Style)
  void showShareSheet(OpportunityModel opportunity) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bagikan ke Teman',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            // List Teman (Horizontal)
            SizedBox(
              height: 100,
              child: Obx(() {
                if (conversations.isEmpty) {
                  return const Center(child: Text('Belum ada teman chat'));
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index];
                    return _buildFriendShareItem(conv, opportunity);
                  },
                );
              }),
            ),
            
            const Divider(),
            
            // Action Luar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildExternalAction(Icons.link, 'Salin Link', () {
                    Clipboard.setData(ClipboardData(text: 'Lihat kegiatan: ${opportunity.judul}\nhttps://zakkal.apl/opportunity/${opportunity.id}'));
                    Get.back();
                    Get.snackbar('Berhasil', 'Link berhasil disalin');
                  }),
                  _buildExternalAction(Icons.message, 'WhatsApp', () {
                    Get.back();
                    Get.snackbar('Info', 'Fitur ini segera hadir');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendShareItem(ConversationModel conv, OpportunityModel opportunity) {
    final name = getOtherUserName(conv);
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final shareText = 'Lihat kegiatan menarik ini: ${opportunity.judul}\nhttps://zakkal.apl/opportunity/${opportunity.id}';
              await sendMessage(conv.id, text: shareText);
              Get.back();
              Get.snackbar('Berhasil', 'Berhasil dibagikan ke $name');
            },
            child: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Text(name[0].toUpperCase()),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExternalAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFF3F4F5),
            child: Icon(icon, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      final result = await notificationRepo.getNotifications();
      notifications.assignAll(result);
    } catch (e) {
      debugPrint('ERROR NOTIF: $e');
      _handleApiError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleApiError(dynamic e) {
    String errorMsg = e.toString();
    if (errorMsg.contains('401')) {
      storage.logout();
      Get.offAllNamed('/login');
      Future.delayed(const Duration(seconds: 1), () {
        if (!Get.isSnackbarOpen) {
          Get.snackbar(
            'Sesi Berakhir', 
            'Silakan login kembali.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      });
      return;
    }
    debugPrint('API Error: $errorMsg');
  }

  String getOtherUserName(ConversationModel conversation) {
    if (conversation.user1Id == currentUserId) {
      return conversation.user2Name ?? 'User';
    }
    return conversation.user1Name ?? 'User';
  }

  String? getOtherUserPhoto(ConversationModel conversation) {
    if (conversation.user1Id == currentUserId) {
      return conversation.user2Photo;
    }
    return conversation.user1Photo;
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
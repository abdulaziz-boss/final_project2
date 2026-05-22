import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../main_nav/main_nav_controller.dart';
import '../inbox/inbox_controller.dart';
import '../opportunity/widgets/opportunity_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFC),
        elevation: 0,
        scrolledUnderElevation: 1, // Memberikan sedikit bayangan saat scroll
        title: const Row(
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
        actions: [
          Obx(() {
            final inboxController = Get.find<InboxController>();
            final unreadCount = inboxController.unreadNotificationsCount;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF475569),
                  ),
                  onPressed: () {
                    // 1. Pindah ke Tab Inbox (Index 2)
                    Get.find<MainNavController>().changeIndex(2);
                    // 2. Pindah ke Sub-Tab Aktivitas (Index 1)
                    inboxController.changeTab(1);
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF475569)),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.feeds.isEmpty) {
                return const Center(child: Text("Belum ada kegiatan"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: controller.feeds.length,
                itemBuilder: (context, index) {
                  final feed = controller.feeds[index];

                  return Obx(() => OpportunityCard(
                        data: feed.data,
                        applyStatus:
                            controller.applicationMap[feed.data.id],
                      ));
                },
              );
            }),
          ),
        ],
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/home_view.dart';
import '../discover/discover_view.dart';
import '../inbox/inbox_view.dart';
import '../profile/views/profile_view.dart';

import 'main_nav_controller.dart';
import '../inbox/inbox_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const DiscoverView(),
      Inboxpage(),
      const ProfileView(),
    ];

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: pages,
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeIndex,
            selectedItemColor: const Color(0xFF006C49),
            type: BottomNavigationBarType.fixed,

            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Discover",
              ),
              BottomNavigationBarItem(
                icon: Obx(() {
                  if (Get.isRegistered<InboxController>()) {
                    final inboxCtrl = Get.find<InboxController>();
                    final unreadCount = inboxCtrl.unreadNotificationsCount + inboxCtrl.unreadMessagesCount;
                    if (unreadCount > 0) {
                      return Badge(
                        label: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.chat_bubble_outline),
                      );
                    }
                  }
                  return const Icon(Icons.chat_bubble_outline);
                }),
                label: "Inbox",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Profile",
              ),
            ],
          ),
        ));
  }
}
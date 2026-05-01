import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
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
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF475569),
            ),
            onPressed: () {},
          ),
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

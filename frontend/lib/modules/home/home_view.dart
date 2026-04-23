import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../data/models/feed_model.dart';
import '../post/widgets/post_card.dart';
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
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF475569)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF475569)),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.feeds.isEmpty) {
          return const Center(child: Text("Belum ada kegiatan"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.feeds.length,
          itemBuilder: (context, index) {
            final feed = controller.feeds[index];

            switch (feed.type) {
              case FeedType.post:
                return PostCard(data: feed.data);

              case FeedType.opportunity:
                return OpportunityCard(data: feed.data);
            }
          },
        );
      }),
    );
  }    

  // Helper untuk icon interaksi pada Post
  Widget _buildActionIcon({required IconData icon, required Color color, required String count}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
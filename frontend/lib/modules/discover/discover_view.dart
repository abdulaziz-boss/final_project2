import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'discover_controller.dart';
import '../opportunity/widgets/opportunity_card.dart';

class DiscoverView extends GetView<DiscoverController> {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.opportunities.length,
          itemBuilder: (context, index) {
            final data = controller.opportunities[index];

            return OpportunityCard(data: data);
          },
        );
      }),
    );
  }
}
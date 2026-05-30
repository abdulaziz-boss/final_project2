import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'discover_controller.dart';
import '../opportunity/widgets/opportunity_card.dart';

class DiscoverView extends GetView<DiscoverController> {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFC),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, color: Color(0xFF047857), size: 28),
            SizedBox(width: 8),
            Text(
              'GoVolunter',
              style: TextStyle(
                color: Color(0xFF047857),
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          _buildCategoryChips(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.opportunities.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: controller.opportunities.length,
                itemBuilder: (context, index) {
                  final data = controller.opportunities[index];
                  return OpportunityCard(data: data);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Cari kegiatan...',
            hintStyle: TextStyle(color: Color(0xFF8C8D8E), fontSize: 15),
            prefixIcon: Icon(Icons.search, color: Color(0xFF006C49)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
          onChanged: (value) {
            controller.searchQuery.value = value;
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(() {
      final allCategories = [
        {'id': null, 'name': 'Semua'},
        ...controller.categories,
      ];

      return Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: allCategories.length,
          itemBuilder: (context, index) {
            final category = allCategories[index];
            final categoryId = category['id'] as int?;
            final categoryName = category['name'] as String;
            return Obx(() {
              final isSelected =
                  controller.selectedCategoryId.value == categoryId;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Text(categoryName),
                  selected: isSelected,
                  onSelected: (selected) {
                    controller.selectCategory(categoryId);
                  },
                  selectedColor: const Color(0xFF006C49),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF3C4A42),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Tidak ada hasil ditemukan",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}

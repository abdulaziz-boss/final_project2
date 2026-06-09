import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'participants_controller.dart';

class ParticipantsView extends GetView<ParticipantsController> {
  const ParticipantsView({super.key});
  int _countStatus(String status) {
    return controller.participants
        .where((e) => e.status == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Participants"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.participants.isEmpty) {
          return const Center(
            child: Text("Belum ada participant"),
          );
        }

        return ListView.builder(
          itemCount: controller.participants.length,
          itemBuilder: (context, index) {
            final item = controller.participants[index];

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.3,
                    children: [
                      _StatCard(
                        title: "Total",
                        value: controller.totalParticipants.value.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: "Diterima",
                        value: _countStatus('accepted').toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: "Menunggu",
                        value: _countStatus('pending').toString(),
                        icon: Icons.hourglass_empty,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: "Ditolak",
                        value: _countStatus('rejected').toString(),
                        icon: Icons.cancel,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: controller.participants.length,
                    itemBuilder: (context, index) {
                      final item = controller.participants[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(item.user?.name ?? '-'),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.status),
                              const SizedBox(height: 6),

                              if (item.status == 'accepted')
                                const Text(
                                  "Silakan hadiri kegiatan di waktu dan tempat yang sudah ditentukan",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),

                              if (item.status == 'rejected' &&
                                  item.alasan != null &&
                                  item.alasan!.isNotEmpty)
                                Text(
                                  "Alasan: ${item.alasan}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),

                          trailing: _buildAction(item),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  // ===================== ACTION WIDGET =====================

  Widget _buildAction(item) {
    if (item.status == 'accepted') {
      return const _StatusBadge(
        text: "Diterima",
        color: Colors.green,
        icon: Icons.check_circle,
      );
    }

    if (item.status == 'rejected') {
      return const _StatusBadge(
        text: "Ditolak",
        color: Colors.red,
        icon: Icons.cancel,
      );
    }

    // pending
    if (controller.currentUserId.value != controller.opportunityCreatorId.value) {
      return const _StatusBadge(
        text: "Menunggu",
        color: Colors.orange,
        icon: Icons.hourglass_empty,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleActionButton(
          icon: Icons.check,
          color: Colors.green,
          onTap: () {
            controller.updateStatus(item.id, 'accepted');
          },
        ),
        const SizedBox(width: 8),
        _CircleActionButton(
          icon: Icons.close,
          color: Colors.red,
          onTap: () {
            _showRejectDialog(item.id);
          },
        ),
      ],
    );
  }

  // ===================== REJECT DIALOG =====================

  void _showRejectDialog(int id) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Alasan Penolakan"),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Tulis alasan penolakan...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateStatus(
                id,
                'rejected',
                reason: reasonController.text,
              );
              Get.back();
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}

// ===================== CIRCLE BUTTON =====================

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

// ===================== STATUS BADGE =====================

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _StatusBadge({
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
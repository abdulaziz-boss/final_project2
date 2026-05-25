import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'participants_controller.dart';

class ParticipantsView extends GetView<ParticipantsController> {
  const ParticipantsView({super.key});

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

            return Card(
              child: ListTile(
                title: Text(item.user?.name ?? '-'),

                // 🔥 STATUS / ACTION AREA
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
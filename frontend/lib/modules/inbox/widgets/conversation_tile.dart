import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final String? photoUrl;
  final int unreadCount;
  final VoidCallback? onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.photoUrl,
    this.unreadCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== AVATAR =====
            Container(
              width: 56,
              height: 56,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: photoUrl != null && photoUrl!.isNotEmpty
                      ? NetworkImage('${ApiConstants.storageUrl}/$photoUrl')
                      : const NetworkImage('https://placehold.co/56x56')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // ===== NAME + MESSAGE =====
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Nama + Waktu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF191C1D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: unreadCount > 0
                              ? const Color(0xFF059669)
                              : const Color(0xFF6C7A71),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: unreadCount > 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Row: Preview pesan + badge unread
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: unreadCount > 0
                                ? const Color(0xFF191C1D)
                                : const Color(0xFF3C4A42),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFBA1A1A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
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

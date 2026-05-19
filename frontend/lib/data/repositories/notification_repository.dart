import '../models/notification_model.dart';
import '../providers/notification_provider.dart';

class NotificationRepository {
  final NotificationProvider provider;

  NotificationRepository(this.provider);

  // Ambil semua notifikasi
  Future<List<NotificationModel>> getNotifications() async {
    final res = await provider.getNotifications();

    return (res.data['data'] as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  // Tandai sudah dibaca
  Future<void> markAsRead(int notificationId) async {
    await provider.markAsRead(notificationId);
  }

  // Hapus notifikasi
  Future<void> deleteNotification(int notificationId) async {
    await provider.deleteNotification(notificationId);
  }
}
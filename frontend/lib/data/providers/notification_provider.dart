import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';

class NotificationProvider {
  final api = ApiService();

  // GET semua notifikasi
  Future<Response> getNotifications() async {
    return await api.dio.get('notifications');
  }

  // Mark as read
  Future<Response> markAsRead(int notificationId) async {
    return await api.dio.post(
      'notifications/$notificationId/read',
    );
  }

  // Mark all as read
  Future<Response> markAllAsRead() async {
    return await api.dio.post(
      'notifications/read-all',
    );
  }

  // Delete notification
  Future<Response> deleteNotification(int notificationId) async {
    return await api.dio.delete('notifications/$notificationId');
  }
}
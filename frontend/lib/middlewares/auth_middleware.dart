import 'package:flutter/material.dart'; // 🔥 WAJIB
import 'package:get/get.dart';

import '../core/services/storage_service.dart';
import '../routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  final storage = StorageService();

  @override
  RouteSettings? redirect(String? route) {
    final token = storage.getToken();

    if (token == null || token.isEmpty) {
      return const RouteSettings(name: Routes.login);
    }

    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  final storage = StorageService();

  @override
  RouteSettings? redirect(String? route) {
    final token = storage.getToken();

    if (token != null && token.isEmpty) {
      return const RouteSettings(name: Routes.main);
    }

    return null;
  }
}
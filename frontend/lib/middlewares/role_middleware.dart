import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../routes/app_routes.dart';

class RoleMiddleware extends GetMiddleware {
  final String allowedRole;
  final storage = StorageService();

  RoleMiddleware(this.allowedRole);

  @override
  RouteSettings? redirect(String? route) {
    final role = storage.getRole();

    if (role != allowedRole) {
      return const RouteSettings(name: Routes.main);
    }

    return null;
  }
}
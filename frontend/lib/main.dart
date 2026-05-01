import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/bindings/core_binding.dart';
import 'core/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Cek apakah user sudah login (token tersimpan)
    final storage = StorageService();
    final token = storage.getToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: CoreBinding(),
      // Jika token ada → langsung ke /main, jika tidak → ke /login
      initialRoute: isLoggedIn ? Routes.main : Routes.login,
      getPages: AppPages.pages,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/bindings/core_binding.dart';
import 'core/widgets/mobile_frame.dart'; // Import file frame yang baru dibuat

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: CoreBinding(),
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      
      // Menggunakan builder global agar semua halaman otomatis terbungkus frame HP saat di Web/Laptop
      builder: (context, child) {
        return MobileFrame(child: child ?? const SizedBox());
      },
    );
  }
}
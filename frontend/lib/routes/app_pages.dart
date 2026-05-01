import 'package:get/get.dart';
import '../modules/auth/login_view.dart';
import '../modules/home/home_view.dart';
import '../modules/auth/register_view.dart';
import '../modules/auth/auth_binding.dart';
import '../modules/home/home_binding.dart';
import '../modules/main_nav/main_nav_view.dart';
import '../modules/main_nav/main_nav_binding.dart';
import '../middlewares/auth_middleware.dart';
// import '../middlewares/role_middleware.dart';
import '../modules/opportunity/detail/opportunity_detail_view.dart';
import '../modules/opportunity/detail/opportunity_detail_binding.dart';
import '../modules/opportunity/apply/apply_binding.dart';
import '../modules/opportunity/apply/apply_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/main',
      page: () => MainNavView(),
      binding: MainNavBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    // GetPage(
    //   name: '/admin',
    //   page: () => const AdminDashboardView(),
    //   binding: AdminDashboardBinding(),
    //   middlewares: [
    //     AuthMiddleware(),
    //     RoleMiddleware('admin'),
    //   ],
    // ),
    // GetPage(
    //   name: '/super_admin',
    //   page: () => const SuperAdminView(),
    //   middlewares: [
    //     AuthMiddleware(),
    //     RoleMiddleware('super_admin'),
    //   ],
    // ),
    GetPage(
      name: '/opportunityDetail',
      page: () => const OpportunityDetailView(),
      binding: OpportunityDetailBinding(),
    ),

    GetPage(
      name: '/apply',
      page: () => const ApplyView(),
      binding: ApplyBinding(),
    ),
    
  ];
}

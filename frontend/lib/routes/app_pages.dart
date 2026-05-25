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
import '../modules/inbox/chat/chat_view.dart';
import '../modules/inbox/inbox_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/opportunity/bindings/opportunity_binding.dart';
import '../modules/participans/participants_view.dart';
import '../modules/participans/participants_binding.dart';

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

    GetPage(
      name: '/opportunity',
      page: () => HomeView(),
      binding: OpportunityBinding(),
    ),

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

    GetPage(
      name: '/chat',
      page: () {
        final conversationId = Get.arguments as int;
        return ChatView(conversationId: conversationId);
      },
      binding: InboxBinding(),
    ),

    GetPage(
      name: '/profile',
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: '/participants',
      page: () => const ParticipantsView(),
      binding: ParticipantsBinding(),
    ),
    
  ];
}

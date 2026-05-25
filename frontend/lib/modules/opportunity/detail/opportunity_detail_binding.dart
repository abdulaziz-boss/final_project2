import 'package:get/get.dart';
import '../controllers/opportunity_detail_controller.dart';

class OpportunityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpportunityDetailController());
  }
}
import 'package:get/get.dart';
import '../controllers/opportunity_controller.dart';

class OpportunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OpportunityController());
  }
}
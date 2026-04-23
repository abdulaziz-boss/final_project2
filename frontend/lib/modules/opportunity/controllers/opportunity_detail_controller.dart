import 'package:get/get.dart';
import '../../../data/models/opportunity_model.dart';

class OpportunityDetailController extends GetxController {
  late OpportunityModel data;

  @override
  void onInit() {
    data = Get.arguments; // kirim dari card
    super.onInit();
  }
}
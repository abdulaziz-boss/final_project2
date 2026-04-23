import 'package:get/get.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../data/repositories/opportunity_repository.dart';

class OpportunityController extends GetxController {
  final repo = OpportunityRepository();

  var opportunities = <OpportunityModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  Future<void> fetch() async {
    try {
      isLoading.value = true;
      opportunities.value = await repo.getAll();
    } catch (e) {
      print("ERROR OPPORTUNITY: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
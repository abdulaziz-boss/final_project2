import 'package:get/get.dart';
import '../../data/models/opportunity_model.dart';
import '../../data/repositories/opportunity_repository.dart';

class DiscoverController extends GetxController {
  final repo = OpportunityRepository();

  var opportunities = <OpportunityModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchOpportunities();
    super.onInit();
  }

  Future<void> fetchOpportunities() async {
    try {
      isLoading.value = true;

      final data = await repo.getAll();
      opportunities.value = data;

    } catch (e) {
      print("ERROR DISCOVER: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
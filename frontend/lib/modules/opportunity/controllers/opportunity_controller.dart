import 'package:get/get.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../data/repositories/opportunity_repository.dart';
import '../../../core/services/storage_service.dart';

class OpportunityController extends GetxController {
  final repo = OpportunityRepository();

  final StorageService storage = StorageService();

  var opportunities = <OpportunityModel>[].obs;
  var isLoading = false.obs;

  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();

    loadUser();

    fetch();
  }

  Future<void> loadUser() async {
    final user = await storage.getUser();

    if (user != null) {
      userRole.value = user['role'] ?? '';
    }
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
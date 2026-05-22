import 'package:get/get.dart';
import '../../data/models/opportunity_model.dart';
import '../../data/repositories/opportunity_repository.dart';

class DiscoverController extends GetxController {
  final opportunityRepo = OpportunityRepository();

  var opportunities = <OpportunityModel>[].obs;
  var categories = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;
  var selectedCategoryId = Rx<int?>(null);
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchOpportunities();

    debounce(
      searchQuery,
      (_) => fetchOpportunities(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> fetchCategories() async {
    try {
      final data = await opportunityRepo.getCategories();
      categories.value = data;
    } catch (e) {
      print("ERROR FETCH CATEGORIES: $e");
    }
  }

  Future<void> fetchOpportunities() async {
    try {
      isLoading.value = true;
      final data = await opportunityRepo.getAll(
        search: searchQuery.value,
        categoryId: selectedCategoryId.value,
      );
      opportunities.value = data;
    } catch (e) {
      print("ERROR FETCH OPPORTUNITIES: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    fetchOpportunities();
  }
}

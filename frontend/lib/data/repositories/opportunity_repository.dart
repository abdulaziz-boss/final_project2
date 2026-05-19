import '../providers/opportunity_provider.dart';
import '../models/opportunity_model.dart';

class OpportunityRepository {
  final provider = OpportunityProvider();

  Future<List<OpportunityModel>> getAll() async {
    try {
      final res = await provider.getAll();
      final dynamic responseData = res.data;

      List? listData;

      if (responseData is List) {
        listData = responseData;
      } else if (responseData is Map && responseData['data'] != null) {
        listData = responseData['data'];
      }

      if (listData == null) {
        print("OPPORTUNITY REPO: Data format tidak dikenali. Response: $responseData");
        return [];
      }

      return listData.map((e) => OpportunityModel.fromJson(e)).toList();
    } catch (e) {
      print("ERROR OPPORTUNITY REPO: $e");
      return [];
    } 
  }

  Future<Map<String, dynamic>> createOpportunity(dynamic formData) async {
    final res = await provider.createOpportunity(formData);
    return res.data;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final res = await provider.getCategories();
      final data = res.data['data'] as List;
      return data.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print("ERROR OPPORTUNITY REPO GET CATEGORIES: $e");
      return [];
    }
  }
}
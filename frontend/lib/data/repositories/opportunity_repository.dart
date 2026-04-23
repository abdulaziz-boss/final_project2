import '../providers/opportunity_provider.dart';
import '../models/opportunity_model.dart';

class OpportunityRepository {
  final provider = OpportunityProvider();

  Future<List<OpportunityModel>> getAll() async {
    try {
      final res = await provider.getAll();

      final List data = res.data['data'];

      return data.map((e) => OpportunityModel.fromJson(e)).toList();
    } catch (e) {
      print("ERROR OPPORTUNITY: $e");
      return [];
    }
  }
}
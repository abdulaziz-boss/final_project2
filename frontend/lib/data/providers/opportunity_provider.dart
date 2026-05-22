import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

class OpportunityProvider {
  final api = ApiService();

  Future<Response> getAll({String? search, int? categoryId}) async {
    final Map<String, dynamic> params = {};
    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    return await api.dio.get(ApiConstants.opportunities, queryParameters: params);
  }

  Future<Response> createOpportunity(FormData data) async {
    return await api.dio.post(ApiConstants.opportunities, data: data);
  }

  Future<Response> getCategories() async {
    return await api.dio.get('categories');
  }
}
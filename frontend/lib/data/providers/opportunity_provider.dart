import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

class OpportunityProvider {
  final api = ApiService();

  Future<Response> getAll() async {
    return await api.dio.get(ApiConstants.opportunities);
  }

  Future<Response> createOpportunity(FormData data) async {
    return await api.dio.post(ApiConstants.opportunities, data: data);
  }

  Future<Response> getCategories() async {
    return await api.dio.get('categories');
  }
}
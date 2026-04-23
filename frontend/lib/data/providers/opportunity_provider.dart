import 'package:dio/dio.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_constants.dart';

class OpportunityProvider {
  final api = ApiService();

  Future<Response> getAll() async {
    return await api.dio.get(ApiConstants.opportunities);
  }
}
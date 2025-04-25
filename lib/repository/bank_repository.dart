import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/bank.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class BankRepository {
  final ApiClient _apiClient;

  BankRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(dio: Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
        )));

  Future<ApiResponse<List<Bank>>> getBanks() async {
    try {
      final response = await _apiClient.get(ApiConstants.getBanks);
      
      return ApiResponse.fromJson(
        response.data is String ? jsonDecode(response.data) : response.data,
        (data) => (data as List).map((item) => Bank.fromJson(item)).toList(),
      );
    } catch (e) {
      throw Exception('Failed to fetch banks: ${e.toString()}');
    }
  }
} 
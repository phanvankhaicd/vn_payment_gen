import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/business.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';

class BusinessRepository {
  final ApiClient _apiClient;

  BusinessRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(dio: Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
        )));

  /// Tra cứu thông tin doanh nghiệp theo mã số thuế
  /// 
  /// [taxCode] - Mã số thuế của doanh nghiệp
  Future<ApiResponse<Business?>> getBusinessByTaxCode(String taxCode) async {
    try {
      final response = await _apiClient.get('${ApiConstants.getBusiness}/$taxCode');
      
      final dynamic data = response.data is String ? jsonDecode(response.data) : response.data;
      
      return ApiResponse.fromJson(
        data,
        (businessData) => businessData != null ? Business.fromJson(businessData) : null,
      );
    } catch (e) {
      throw Exception('Failed to fetch business info: ${e.toString()}');
    }
  }
} 
import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/bank.dart';
import '../models/business.dart';
import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../repository/bank_repository.dart';
import '../repository/business_repository.dart';
import '../viet_qr/viet_qr_generator.dart';

class VnPaymentApi {
  final BankRepository _bankRepository;
  final BusinessRepository _businessRepository;
  static VnPaymentApi? _instance;
  List<Bank>? _banks;

  VnPaymentApi._({
    BankRepository? bankRepository,
    BusinessRepository? businessRepository,
  }) : _bankRepository = bankRepository ?? BankRepository(),
       _businessRepository = businessRepository ?? BusinessRepository();

  /// Initialize the VnPaymentApi instance
  static Future<VnPaymentApi> init({
    BankRepository? bankRepository,
    BusinessRepository? businessRepository,
  }) async {
    if (_instance == null) {
      _instance = VnPaymentApi._(
        bankRepository: bankRepository,
        businessRepository: businessRepository,
      );
      // Pre-fetch banks data when initializing
      await _instance!.getBanks(forceRefresh: true);
    }
    return _instance!;
  }

  /// Get the singleton instance of VnPaymentApi
  /// Throws an exception if not initialized
  static VnPaymentApi get instance {
    if (_instance == null) {
      throw Exception('VnPaymentApi not initialized. Call VnPaymentApi.init() first.');
    }
    return _instance!;
  }

  /// Fetches the list of banks from the API
  /// Returns ApiResponse with list of banks on success
  Future<ApiResponse<List<Bank>>> getBanks({bool forceRefresh = false}) async {
    // Return cached banks if available and not forcing refresh
    if (_banks != null && !forceRefresh) {
      return ApiResponse(
        code: '00',
        desc: 'Get Bank list successful! Total ${_banks!.length} banks',
        data: _banks!,
      );
    }

    // Fetch from API
    final response = await _bankRepository.getBanks();
    
    // Cache if successful
    if (response.isSuccess) {
      _banks = response.data;
    }
    
    return response;
  }

  /// Returns the cached list of banks or null if not fetched yet
  List<Bank>? get banks => _banks;
  
  /// Tìm ngân hàng theo mã code
  Bank? findBankByCode(String code) {
    if (_banks == null) return null;
    
    try {
      return _banks!.firstWhere((bank) => bank.code.toLowerCase() == code.toLowerCase());
    } catch (_) {
      return null;
    }
  }
  
  /// Tìm ngân hàng theo BIN
  Bank? findBankByBin(String bin) {
    if (_banks == null) return null;
    
    try {
      return _banks!.firstWhere((bank) => bank.bin == bin);
    } catch (_) {
      return null;
    }
  }
  
  /// Tạo URL QR cho ngân hàng và số tài khoản
  String generateQrUrl({
    required String bankId,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
  }) {
    return VietQrGenerator.generateQrUrl(
      bankId: bankId,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
    );
  }
  
  /// Tạo URL QR cho ngân hàng dựa trên BIN
  String generateQrUrlFromBankCode({
    required String bankCode,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
  }) {
    final bank = findBankByCode(bankCode);
    if (bank == null) {
      throw Exception('Bank with code $bankCode not found');
    }
    
    return VietQrGenerator.generateQrUrl(
      bankId: bank.bin,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
    );
  }
  
  /// Tra cứu thông tin doanh nghiệp theo mã số thuế
  /// 
  /// [taxCode] - Mã số thuế của doanh nghiệp
  Future<ApiResponse<Business?>> getBusinessByTaxCode(String taxCode) async {
    return _businessRepository.getBusinessByTaxCode(taxCode);
  }
} 
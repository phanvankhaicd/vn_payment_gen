import 'vn_payment_gen_platform_interface.dart';
import 'models/bank.dart';
import 'models/api_response.dart';
import 'models/business.dart';
import 'api/vn_payment_api.dart';
import 'widgets/viet_qr_image.dart';
import 'viet_qr/viet_qr_generator.dart';

class VnPaymentGen {
  static VnPaymentGen? _instance;

  /// Khởi tạo VnPaymentGen và các API cần thiết
  static Future<VnPaymentGen> init() async {
    if (_instance == null) {
      // Khởi tạo API
      await VnPaymentApi.init();
      _instance = VnPaymentGen._();
    }
    return _instance!;
  }

  /// Lấy instance của VnPaymentGen, yêu cầu phải gọi init() trước
  static VnPaymentGen get instance {
    if (_instance == null) {
      throw Exception('VnPaymentGen not initialized. Call VnPaymentGen.init() first.');
    }
    return _instance!;
  }

  // Private constructor
  VnPaymentGen._();

  // Factory constructor for convenience
  factory VnPaymentGen() {
    if (_instance == null) {
      throw Exception('VnPaymentGen not initialized. Call VnPaymentGen.init() first.');
    }
    return _instance!;
  }

  Future<String?> getPlatformVersion() {
    return VnPaymentGenPlatform.instance.getPlatformVersion();
  }

  /// Fetches the list of banks from the API
  /// Returns ApiResponse with list of banks on success
  Future<ApiResponse<List<Bank>>> getBanks({bool forceRefresh = false}) async {
    return VnPaymentApi.instance.getBanks(forceRefresh: forceRefresh);
  }

  /// Returns the cached list of banks or null if not fetched yet
  List<Bank>? get banks => VnPaymentApi.instance.banks;
  
  /// Tìm ngân hàng theo mã code
  Bank? findBankByCode(String code) {
    return VnPaymentApi.instance.findBankByCode(code);
  }
  
  /// Tìm ngân hàng theo BIN
  Bank? findBankByBin(String bin) {
    return VnPaymentApi.instance.findBankByBin(bin);
  }
  
  /// Tạo URL QR từ thông tin ngân hàng và số tài khoản
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
  
  /// Tạo URL QR từ mã ngân hàng
  String generateQrUrlFromBankCode({
    required String bankCode,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
  }) {
    return VnPaymentApi.instance.generateQrUrlFromBankCode(
      bankCode: bankCode,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
    );
  }
  
  /// Cung cấp Widget VietQrImage để sử dụng trong ứng dụng
  VietQrImage getQrImage({
    required String bankId,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
    double? width,
    double? height,
  }) {
    return VietQrImage(
      bankId: bankId,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
      width: width,
      height: height,
    );
  }
  
  /// Tạo QR Image từ mã ngân hàng
  VietQrImage getQrImageFromBankCode({
    required String bankCode,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
    double? width,
    double? height,
  }) {
    final bank = findBankByCode(bankCode);
    if (bank == null) {
      throw Exception('Bank with code $bankCode not found');
    }
    
    return VietQrImage(
      bankId: bank.bin,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
      width: width,
      height: height,
    );
  }
  
  /// Tra cứu thông tin doanh nghiệp theo mã số thuế
  /// 
  /// [taxCode] - Mã số thuế của doanh nghiệp
  Future<ApiResponse<Business?>> getBusinessByTaxCode(String taxCode) async {
    return VnPaymentApi.instance.getBusinessByTaxCode(taxCode);
  }
  
  /// Các mẫu QR có sẵn
  static String get templateCompact => VietQrGenerator.templateCompact;
  static String get templateCompact2 => VietQrGenerator.templateCompact2;
  static String get templateQr => VietQrGenerator.templateQr;
  static String get templateQrOnly => VietQrGenerator.templateQr2;
}

/// Helper class để xây dựng các URL VietQR
class VietQrGenerator {
  /// URL cơ sở cho VietQR
  static const String baseUrl = 'https://img.vietqr.io/image';
  
  /// Các template mặc định
  static const String templateCompact = 'compact';
  static const String templateCompact2 = 'compact2';
  static const String templateQr = 'qr';
  static const String templateQr2 = 'qr-only';
  
  /// Tạo URL QR từ các tham số
  /// 
  /// [bankId] - Mã ngân hàng (yêu cầu)
  /// [accountNo] - Số tài khoản (yêu cầu)
  /// [template] - Mẫu QR (mặc định là compact)
  /// [amount] - Số tiền (không bắt buộc)
  /// [addInfo] - Thông tin bổ sung (không bắt buộc)
  /// [accountName] - Tên tài khoản (không bắt buộc)
  static String generateQrUrl({
    required String bankId, 
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
  }) {
    final baseUrlWithParams = '$baseUrl/$bankId-$accountNo-$template.png';
    
    final queryParams = <String, String>{};
    
    if (amount != null) {
      queryParams['amount'] = amount.toString();
    }
    
    if (addInfo != null) {
      queryParams['addInfo'] = Uri.encodeComponent(addInfo);
    }
    
    if (accountName != null) {
      queryParams['accountName'] = Uri.encodeComponent(accountName);
    }
    
    if (queryParams.isEmpty) {
      return baseUrlWithParams;
    }
    
    final queryString = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$baseUrlWithParams?$queryString';
  }
  
  /// Tạo URL QR từ mã BIN của ngân hàng
  /// 
  /// [bankBin] - Mã BIN của ngân hàng
  /// [accountNo] - Số tài khoản
  /// Các tham số khác tương tự như [generateQrUrl]
  static String generateQrUrlFromBin({
    required String bankBin, 
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
  }) {
    return generateQrUrl(
      bankId: bankBin, 
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
    );
  }
} 
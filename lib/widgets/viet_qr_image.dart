import 'package:flutter/material.dart';
import '../viet_qr/viet_qr_generator.dart';

/// Widget hiển thị mã QR từ VietQR
class VietQrImage extends StatelessWidget {
  /// Mã ngân hàng
  final String bankId;
  
  /// Số tài khoản
  final String accountNo;
  
  /// Mẫu QR (mặc định là compact)
  final String template;
  
  /// Số tiền (không bắt buộc)
  final int? amount;
  
  /// Thông tin bổ sung (không bắt buộc)
  final String? addInfo;
  
  /// Tên tài khoản (không bắt buộc)
  final String? accountName;
  
  /// Kích thước của ảnh QR
  final double? width;
  final double? height;
  
  /// Widget hiển thị khi đang tải ảnh
  final Widget? loadingWidget;
  
  /// Widget hiển thị khi có lỗi
  final Widget? errorWidget;

  const VietQrImage({
    super.key,
    required this.bankId,
    required this.accountNo,
    this.template = 'compact',
    this.amount,
    this.addInfo,
    this.accountName,
    this.width,
    this.height,
    this.loadingWidget,
    this.errorWidget,
  });
  
  /// Tạo widget với mã BIN của ngân hàng
  factory VietQrImage.fromBin({
    required String bankBin,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
    double? width,
    double? height,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return VietQrImage(
      bankId: bankBin,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
      width: width,
      height: height,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }
  
  /// Tạo widget từ đối tượng Bank
  factory VietQrImage.fromBank({
    required dynamic bank,
    required String accountNo,
    String template = 'compact',
    int? amount,
    String? addInfo,
    String? accountName,
    double? width,
    double? height,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    String bankId;
    
    if (bank is String) {
      bankId = bank;
    } else if (bank is Map<String, dynamic>) {
      bankId = bank['bin'] ?? bank['code'] ?? bank['id'] ?? '';
    } else {
      try {
        // Assume it's a Bank object with a bin property
        bankId = bank.bin ?? bank.code ?? '';
      } catch (_) {
        bankId = '';
      }
    }
    
    return VietQrImage(
      bankId: bankId,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
      width: width,
      height: height,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = VietQrGenerator.generateQrUrl(
      bankId: bankId,
      accountNo: accountNo,
      template: template,
      amount: amount,
      addInfo: addInfo,
      accountName: accountName,
    );
    
    return Image.network(
      url,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        
        return loadingWidget ?? Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Center(
          child: Icon(Icons.error, color: Colors.red),
        );
      },
    );
  }
} 
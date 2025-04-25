
import 'vn_payment_gen_platform_interface.dart';

class VnPaymentGen {
  Future<String?> getPlatformVersion() {
    return VnPaymentGenPlatform.instance.getPlatformVersion();
  }
}

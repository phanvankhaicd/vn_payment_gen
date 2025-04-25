import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vn_payment_gen_platform_interface.dart';

/// An implementation of [VnPaymentGenPlatform] that uses method channels.
class MethodChannelVnPaymentGen extends VnPaymentGenPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vn_payment_gen');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

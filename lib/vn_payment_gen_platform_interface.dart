import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'vn_payment_gen_method_channel.dart';

abstract class VnPaymentGenPlatform extends PlatformInterface {
  /// Constructs a VnPaymentGenPlatform.
  VnPaymentGenPlatform() : super(token: _token);

  static final Object _token = Object();

  static VnPaymentGenPlatform _instance = MethodChannelVnPaymentGen();

  /// The default instance of [VnPaymentGenPlatform] to use.
  ///
  /// Defaults to [MethodChannelVnPaymentGen].
  static VnPaymentGenPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VnPaymentGenPlatform] when
  /// they register themselves.
  static set instance(VnPaymentGenPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

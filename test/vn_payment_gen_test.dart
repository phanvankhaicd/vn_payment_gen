import 'package:flutter_test/flutter_test.dart';
import 'package:vn_payment_gen/vn_payment_gen.dart';
import 'package:vn_payment_gen/vn_payment_gen_platform_interface.dart';
import 'package:vn_payment_gen/vn_payment_gen_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVnPaymentGenPlatform
    with MockPlatformInterfaceMixin
    implements VnPaymentGenPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VnPaymentGenPlatform initialPlatform = VnPaymentGenPlatform.instance;

  test('$MethodChannelVnPaymentGen is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVnPaymentGen>());
  });

  test('getPlatformVersion', () async {
    VnPaymentGen vnPaymentGenPlugin = VnPaymentGen();
    MockVnPaymentGenPlatform fakePlatform = MockVnPaymentGenPlatform();
    VnPaymentGenPlatform.instance = fakePlatform;

    expect(await vnPaymentGenPlugin.getPlatformVersion(), '42');
  });
}

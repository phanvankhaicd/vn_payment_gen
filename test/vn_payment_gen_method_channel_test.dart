import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vn_payment_gen/vn_payment_gen_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelVnPaymentGen platform = MethodChannelVnPaymentGen();
  const MethodChannel channel = MethodChannel('vn_payment_gen');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

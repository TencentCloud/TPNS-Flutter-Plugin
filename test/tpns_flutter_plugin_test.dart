import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('tpns_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await XgFlutterPlugin.platformVersion, '42');
  });
}

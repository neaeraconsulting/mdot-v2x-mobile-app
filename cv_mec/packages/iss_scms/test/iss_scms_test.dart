import 'package:flutter_test/flutter_test.dart';
import 'package:iss_scms/iss_scms.dart';
import 'package:iss_scms/iss_scms_platform_interface.dart';
import 'package:iss_scms/iss_scms_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIssScmsPlatform
    with MockPlatformInterfaceMixin
    implements IssScmsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IssScmsPlatform initialPlatform = IssScmsPlatform.instance;

  test('$MethodChannelIssScms is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIssScms>());
  });

  test('getPlatformVersion', () async {
    IssScms issScmsPlugin = IssScms();
    MockIssScmsPlatform fakePlatform = MockIssScmsPlatform();
    IssScmsPlatform.instance = fakePlatform;

    expect(await issScmsPlugin.getPlatformVersion(), '42');
  });
}

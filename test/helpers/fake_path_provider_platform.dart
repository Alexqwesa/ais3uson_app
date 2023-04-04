import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fake_data.dart';

/// [WorkerKey] modified for tests (ssl='no')
WorkerKey wKeysData2() {
  final json = jsonDecode(qrData2WithAutossl) as Map<String, dynamic>;
  // json['ssl'] = 'no';

  return WorkerKey.fromJson(json);
}

class FakePathProviderPlatform extends Fake
    with
        // ignore: prefer_mixin
        MockPlatformInterfaceMixin
    implements
        PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '/tmp';
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return '/tmp';
  }
}

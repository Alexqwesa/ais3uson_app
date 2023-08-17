import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

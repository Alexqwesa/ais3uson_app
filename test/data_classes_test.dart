import 'dart:convert';

import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';

import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    await mySetUpAll();
  });
  tearDownAll(() async {
    await tearDownTestHive();
  });
  group('Worker Profile', () {
    test('create WorkerProfile', () async {
      expect(
        await () async {
          return WorkerProfile(WorkerKey.fromJson(jsonDecode(qrData2)));
        }(),
        isA<WorkerProfile>(),
      );
    });
    test('test json converters classes', () async {
      final wKey = WorkerKey.fromJson(jsonDecode(qrData2));
      expect(wKey, isA<WorkerKey>());
      expect(wKey.apiKey, (jsonDecode(qrData2) as Map)['api_key']);
      expect(wKey.toJson(), jsonDecode(qrData2));
    });
  });
}

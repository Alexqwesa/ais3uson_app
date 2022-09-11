import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart' show ExtMock, getMockHttpClient;
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.mocks.dart' as mock;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_models_test.dart';

void main() {
  setUpAll(() async {
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
    // add profile
    // await locator<AppData>().addProfileFromKey(wKeysData2());
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  test('it state providers work', () async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certBase64)
            .overrideWithValue(getMockHttpClient()),
      ],
    );
    //
    // > it create workerProfiles
    //
    ref.read(workerProfiles.notifier).addProfileFromKey(wKey);
    // ref.read(workerKeys.notifier).addKey(wKey);
    final wp = ref.read(workerProfiles).first;
    expect(ref.read(hiveBox(hiveProfiles)).value?.isOpen, null);
    expect(wp.clients.length, 0);
    //
    // > it open hiveBox
    //
    await wp.postInit(); // or await ref.read(hiveBox(hiveProfiles).future);
    expect(ref.read(hiveBox(hiveProfiles)).value?.isOpen, true);
    //
    // > it sync clients list
    //
    final httpClient =
        ref.read(httpClientProvider(wKey.certBase64)) as mock.MockClient;
    await wp.syncClients(); // second call of testReqGetClients
    await wp.postInit(); // it didn't make initial sync twice
    expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 2);
    expect(
      ref.read(httpDataProvider(wp.apiUrlClients)).length,
      10,
    );
    expect(wp.clients.length, 10);
    //
    // > it read first client
    //
    expect(
      wp.clients.first.contract,
      '661/2021/t/2001',
    );
    //
    // > it read lastClient
    //
    ref.read(lastUsed).client = wp.clients[3];
    expect(ref.read(lastUsed).client.contract, '701/2021/t/2017');
    //
    // > it read last service
    //
    final service = ref.read(lastUsed).client.services[3];
    ref.read(lastUsed).service = service;
    expect(ref.read(lastUsed).service, service);
    //
    // > archive state
    //
    // ref.read(archiveDate.notifier).state = DateTime(2022, 3);
    // ref.read(isArchive.notifier).state = true;
    // expect(ref.read(archiveDate), DateTime(2022, 3));
    // ref.read(isArchive.notifier).state = false;
    // await ref.pump();
    // expect(ref.read(archiveDate), null);
  });
}

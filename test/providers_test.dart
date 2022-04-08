import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/app_state.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/worker_keys_and_profiles.dart';
import 'package:ais3uson_app/source/providers/worker_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

import 'data_classes_test.dart';
import 'helpers/mock_server.dart';
import 'helpers/mock_server.dart' show ExtMock, getMockHttpClient;
import 'helpers/mock_server.mocks.dart' as mock;

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

  test('it providers work', () async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certificate)
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
    await wp.postInit();
    // await ref.read(hiveBox(hiveProfiles).future);
    expect(ref.read(hiveBox(hiveProfiles)).value?.isOpen, true);
    //
    // > it sync clients list
    //
    await ref
        .read(httpDataProvider(Tuple2(wp.apiKey, wp.urlClients)).notifier)
        .syncHiveHttp();
    await wp.syncHiveClients();
    await ref
        .read(httpDataProvider(Tuple2(wp.apiKey, wp.urlClients)).notifier)
        .syncHiveHttp(); // it didn't make initial sync twice
    final httpClient =
    ref.read(httpClientProvider(wKey.certificate)) as mock.MockClient;
    expect(verify(ExtMock(httpClient).testReqGetClients).callCount, 2);
    expect(
      ref.read(httpDataProvider(Tuple2(wp.apiKey, wp.urlClients))).length,
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
    ref.read(lastApiKey.notifier).state = wp.apiKey;
    ref.read(lastClientId.notifier).state = wp.clients[3].contractId;
    expect(ref.read(lastClient).contract, '701/2021/t/2017');
  });
}

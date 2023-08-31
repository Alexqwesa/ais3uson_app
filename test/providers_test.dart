import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show MockServer;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/extensions/worker_extension.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
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
    // > prepare ProviderContainer + httpClient + worker
    final (ref, _, wp, httpClient) = await openRefContainer();
    // ----
    expect(ref.read(hiveBox(hiveHttpCache)).value?.isOpen, true); // preOpen
    expect(wp.clients.length, 0);
    //
    // > it open hiveBox
    //
    await wp.postInit(); // or await ref.read(hiveBox(hiveProfiles).future);
    expect(ref.read(hiveBox(hiveHttpCache)).value?.isOpen, true);
    //
    // > it sync clients list
    //
    await wp.syncClients(); // second call of testReqGetClients
    await wp.postInit(); // it didn't make initial sync twice
    expect(verify(MockServer(httpClient).testReqGetClients).callCount, 2);
    expect(
      ref.read(httpProvider(wp.apiKey, Worker.urlClients)).length,
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

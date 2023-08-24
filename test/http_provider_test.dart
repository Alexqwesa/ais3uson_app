import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/stubs_for_testing/mock_server.dart'
    show MockServer;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/real_hive_helpler.dart';
import 'helpers/worker_profile_test_extensions.dart';

void main() {
  //
  // > Setup
  //
  tearDownAll(() async {
    await tearDownRealHive();
  });
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    locator.pushNewScope();
    // Hive setup
    await setUpRealHive();
  });
  tearDown(() async {
    await tearDownRealHive();
  });

  //
  // > Tests start
  //
  group('http Provider', () {
    test('it get services', () async {
      // > prepare ProviderContainer + httpClient + worker
      final (ref, _, wp, httpClient) = await openRefContainer();
      // ----
      var clients = ref.read(httpProvider(wp.apiKey, wp.urlClients));
      expect(clients.isEmpty, true);
      // await ref.read(httpProvider(wp.apiKey, wp.urlClients).notifier).future();
      // ref.refresh(httpProvider(wp.apiKey, wp.urlClients));
      // await ref.pump();

      await ref
          .read(httpProvider(wp.apiKey, wp.urlClients).notifier)
          .getHttpData();
      clients = ref.read(httpProvider(wp.apiKey, wp.urlClients));
      expect(clients.isEmpty, false);
      expect(verify(MockServer(httpClient).testReqGetClients).callCount, 1);
    });
  });
}

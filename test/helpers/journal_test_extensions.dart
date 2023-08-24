import 'package:ais3uson_app/journal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

extension JournalTestExtensions on Journal {
  /// Only for tests! Don't use in real code.
  Future<void> postInit() async {
    // final ref_test = ref as ProviderContainer;
    // ref_test.refresh(hiveRepositoryProvider(apiKey));
    // await ref_test.pump();
    await Hive.openBox<ServiceOfJournal>(journalHiveName);
    // await Hive.openBox<ServiceOfJournal>(hiveRepository.archiveHiveName);
    ref.watch(hiveRepositoryProvider(apiKey));
    await Future.delayed(const Duration(seconds: 1));
    expect(ref.watch(hiveRepositoryProvider(apiKey).notifier).init, true);

    //   //
    //   // > read hive at date or all
    //   //
    //   // await ref.read(datesInArchive.future);
    //   hiveRepository.hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
    //   await hiveRepository.initAsync();
  }
}

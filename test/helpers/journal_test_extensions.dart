import 'package:ais3uson_app/journal.dart';
import 'package:hive/hive.dart';

extension JournalTestExtensions on Journal {
  /// Only for tests! Don't use in real code.
  Future<void> postInit() async {
    //
    // > read hive at date or all
    //
    // await ref.read(datesInArchive.future);
    hiveRepository.hive = await Hive.openBox<ServiceOfJournal>(journalHiveName);
    await hiveRepository.initAsync();
  }
}

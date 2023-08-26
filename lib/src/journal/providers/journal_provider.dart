import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_provider.g.dart';

@Riverpod(keepAlive: true)
Journal journal(Ref ref, String apiKey) {
  final worker = ref.watch(workerByApiProvider(apiKey));
  final appState = ref.watch(appStateIsProvider);
  if (appState.isArchive) {
    if (appState.showAll) {
      return JournalArchiveAll(worker, appState); // with date == null
    } else if (appState.atDate != null) {
      return JournalArchive(worker, appState);
    } else {
      throw StateError('Impossible state of ArchiveStateProvider ');
    }
  } else {
    // not Archive
    return Journal(worker, appState);
  }
}

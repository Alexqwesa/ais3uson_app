import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'journal_provider.g.dart';

@Riverpod(keepAlive: true)
Journal journal(Ref ref, String apiKey) {
  final appState = ref.watch(appStateProvider);
  if (appState.isArchive) {
    if (appState.showAll) {
      return JournalArchiveAll(
          ref: ref, apiKey: apiKey, state: appState); // with date == null
    } else if (appState.atDate != null) {
      return JournalArchive(ref: ref, apiKey: apiKey, state: appState);
    } else {
      throw StateError('Impossible state of ArchiveStateProvider ');
    }
  } else {
    // not Archive
    return Journal(ref: ref, apiKey: apiKey, state: appState);
  }
}

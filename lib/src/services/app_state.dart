// ignore_for_file: camel_case_types

import 'package:ais3uson_app/global_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state.g.dart';

/// Global state of App:
///
/// - Archive view or usual view of App?,
/// - show archive at which day?,
/// - or show all.
///
/// {@category Providers}
/// {@category App State}
@Riverpod(keepAlive: true)
class appState extends _$appState {
  @override
  AppState build() {
    return AppState.active(ref);
  }

  @override
  set state(AppState appState) => state = appState;
}

/// The actual state provided by [appStateProvider].
class AppState {
  final bool isArchive;
  final DateTime? atDate;
  final bool showAll;
  final Ref ref;

  const AppState.active(this.ref)
      : isArchive = false,
        atDate = null,
        showAll = false;

  const AppState.archiveDate(this.ref, this.atDate)
      : isArchive = true,
        showAll = false;

  const AppState.archiveAll(this.ref)
      : isArchive = true,
        atDate = null,
        showAll = true;

  String get dateAsString =>
      atDate == null ? 'null' : standardFormat.format(atDate!);

  /// Change state of [appStateProvider].
  void toArchiveDate(DateTime date) =>
      ref.read(appStateProvider.notifier).state =
          AppState.archiveDate(ref, date.dateOnly());

  /// Change state of [appStateProvider].
  void toArchiveAll() =>
      ref.read(appStateProvider.notifier).state = AppState.archiveAll(ref);

  /// Change state of [appStateProvider].
  void toActive() =>
      ref.read(appStateProvider.notifier).state = AppState.active(ref);
}

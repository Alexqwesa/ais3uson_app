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
class AppStateIs extends _$AppStateIs {
  @override
  AppState build() {
    return AppState(isArchive: false, ref: ref);
  }

  // ignore: use_setters_to_change_properties
  void setState(AppState appState) => state = appState;
}

class AppState {
  final bool isArchive;

  final DateTime? atDate;

  final bool showAll;

  final Ref ref;

  AppState({
    required this.isArchive,
    required this.ref,
    this.atDate,
    this.showAll = true,
  }) :
        assert(!isArchive ||
            (isArchive && (!showAll && (atDate != null)) ||
                showAll && (atDate == null)));

  /// Change state of Notifier of [appStateIsProvider].
  void set({bool? isArchive, DateTime? atDate, bool? showAll}) {
    final archive = isArchive ?? (atDate != null || this.isArchive);
    if (!archive) {
      ref.read(appStateIsProvider.notifier).setState(AppState(
            isArchive: false,
            ref: ref,
          ));
    } else {
      final date = atDate ?? this.atDate;
      ref.read(appStateIsProvider.notifier).setState(AppState(
            isArchive: true,
            atDate: date,
            showAll: date == null || (showAll ?? this.showAll),
            ref: ref,
          ));
    }
  }

  String get dateAsString =>
      atDate == null ? 'null' : standardFormat.format(atDate!);
}

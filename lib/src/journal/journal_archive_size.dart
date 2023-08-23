import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'journal_archive_size.g.dart';

/// Provider of setting - max amount of entries stored in [Journal].
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
/// {@category Journal}
@riverpod
class JournalArchiveSize extends _$JournalArchiveSize {
  static const name = 'HiveArchiveLimitState';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }

  @override
  int build() {
    return locator<SharedPreferences>().getInt(name) ?? 3000;
  }
}

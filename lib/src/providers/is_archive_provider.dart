import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_archive_provider.g.dart';

/// Provider of state - archiveDate.
///
/// {@category Providers}
/// {@category App State}
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});

/// Global switch: Archive view or usual view of App.
///
/// {@category Providers}
/// {@category App State}
// Todo: only use archiveDate?
@Riverpod(keepAlive: true)
class IsArchive extends _$IsArchive {
  @override
  bool build() {
    return false;
  }

  @override
  set state(bool value) {
    super.state = value;
    if (!value) {
      ref.read(archiveDate.notifier).state = null;
    }
  }
}

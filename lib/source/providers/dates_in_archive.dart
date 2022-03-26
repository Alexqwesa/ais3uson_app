import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dates which have archived services
/// Provider of setting - datesInArchive.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [hiveDateTimeBox] ('allArchiveDates').
///
/// {@category Providers}
final datesInArchive = FutureProvider((ref) async {
  await ref.watch(hiveDateTimeBox('allArchiveDates').future);

  return ref.watch(hiveDateTimeBox('allArchiveDates')).when(
        data: (e) => ref.watch(innerDatesInArchive),
        error: (e, stack) => ref.watch(innerDatesInArchive),
        loading: () => null,
      );
});

final innerDatesInArchive =
    StateNotifierProvider<DatesInArchiveState, List<DateTime>>((ref) {
  return DatesInArchiveState(ref.watch(hiveDateTimeBox('allArchiveDates')));
});

class DatesInArchiveState extends StateNotifier<List<DateTime>> {
  late final Box<DateTime>? box;
  final AsyncValue<Box<DateTime>> asyncOpenBox;

  @override
  set state(List<DateTime> value) {
    super.state = [...value];
    //
    // > save
    //
    if (box != null) {
      () async {
        await box!.clear();
        await box!.compact();
        await box!.addAll(value);
      }();
    }
  }

  DatesInArchiveState(this.asyncOpenBox) : super([]) {
    asyncOpenBox.whenData((data) {
      box = data;
      // state probably empty here...
      log.info('Not empty: state of DatesInArchiveState');
      super.state = <DateTime>{...state, ...box!.values}.toList();
    });
  }

  void addAll(Iterable<DateTime> map) {
    state = <DateTime>{...state, ...map}.toList();
  }
}

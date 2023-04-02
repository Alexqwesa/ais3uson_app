import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dates at which where exist archived services in [WorkerProfile].
/// Depend on [hiveDateTimeBox] ('allArchiveDates').
///
/// {@category Providers}
final controllerDatesInArchive = StateNotifierProvider.family<
    _ControllerDatesInArchive, List<DateTime>, String>(
  (ref, apiKey) {
    return _ControllerDatesInArchive(ref, apiKey);
  },
);

class _ControllerDatesInArchive extends StateNotifier<List<DateTime>> {
  _ControllerDatesInArchive(this.ref, this.apiKey) : super([]) {
    hiveName = 'allArchiveDates_$apiKey';
    ref.read(hiveDateTimeBox(hiveName)).whenData((data) {
      super.state = <DateTime>{...state, ...data.values}.toList();
    });
  }

  late final String hiveName;
  final String apiKey;
  final StateNotifierProviderRef ref;
  bool _saved = false;

  Future<List<DateTime>> inited() async {
    await ref.read(hiveDateTimeBox(hiveName).future);
    // log.info(state);

    return state;
  }

  Future<void> updateFrom(Iterable<ServiceOfJournal> newDates) async {
    state = newDates
        .map((element) => element.provDate)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toList();
    await save();
  }

  /// Future for await save.
  Future<void> save() async {
    if (!_saved) {
      await _saveAll();
      _saved = true;
    }
  }

  Future<bool> _saveAll() async {
    await ref.read(hiveDateTimeBox(hiveName).future);
    final box = ref.read(hiveDateTimeBox(hiveName)).value;
    // await box!.clear();
    if (box != null) {
      await box.compact();
      await box.addAll(state.whereNot((el) => box.values.contains(el)));

      return true;
    }

    return false;
  }

  @override
  set state(List<DateTime> value) {
    super.state = [...value];
    //
    // > save
    //
    _saved = false;
  }

  void addAll(Iterable<DateTime> map) {
    state = <DateTime>{...state, ...map}.toList();
  }
}

/// Provider of list of dates at which there are exist archived services
/// in all [WorkerProfile]s, if empty will try to reinitialize all underlying lists
/// by calling [Journal.updateDatesInArchiveOfProfile] for each.
///
/// (aggregate from [controllerDatesInArchive]).
///
/// {@category Providers}
/// {@category Controllers}
final initDatesInAllArchives = FutureProvider((ref) async {
  Future<void> initControllers() async {
     await Future.wait([
      ...ref.watch(workerProfiles).map((e) async =>
          ref.watch(controllerDatesInArchive(e.apiKey).notifier).inited()),
    ]);
  }

  if (ref.watch(datesInAllArchives).isEmpty) {
    await Future.wait(ref
        .read(workerProfiles)
        .map((e) async => e.journal.updateDatesInArchiveOfProfile()));
    await initControllers();
  }

  return ref.watch(datesInAllArchives);
});

/// Dates at which there are exist archived services (aggregate from
/// [controllerDatesInArchive]).
///
/// The same as [initDatesInAllArchives] but don't try to reinitialize if empty.
///
/// {@category Providers}
final datesInAllArchives = Provider<Set<DateTime>>((ref) {
  return <DateTime>{
    ...ref
        .watch(workerProfiles)
        .map((e) => ref.watch(controllerDatesInArchive(e.apiKey)))
        .expand((list) => list)
        .toList(),
  };
});

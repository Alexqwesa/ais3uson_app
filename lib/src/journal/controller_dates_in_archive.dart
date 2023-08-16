import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dates at which where exist archived services in [WorkerProfile].
/// Depend on [hiveDateTimeBox] ('allArchiveDates').
///
/// {@category Providers}
final controllerDatesInArchive = StateNotifierProvider.family<
    _ControllerDatesInArchive, Set<DateTime>, String>(
  (ref, apiKey) {
    return _ControllerDatesInArchive(ref, apiKey);
  },
);

class _ControllerDatesInArchive extends StateNotifier<Set<DateTime>> {
  _ControllerDatesInArchive(this.ref, this.apiKey) : super({}) {
    hiveName = 'allArchiveDates_$apiKey';
    ref.read(hiveDateTimeBox(hiveName)).whenData((data) {
      super.state = <DateTime>{...state, ...data.values};
    });
  }

  late final String hiveName;
  final String apiKey;
  final Ref ref;
  bool _saved = false;

  Future<Set<DateTime>> _initialize() async {
    await ref.read(hiveDateTimeBox(hiveName).future);
    // log.info(state);

    return state;
  }

  Future<void> updateFrom(Iterable<ServiceOfJournal> newDates) async {
    state = newDates
        .map((element) => element.provDate)
        .map((e) => DateTime(e.year, e.month, e.day))
        .toSet();
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
  set state(Set<DateTime> value) {
    super.state = {...value};
    //
    // > save
    //
    _saved = false;
  }

  void addAll(Iterable<DateTime> map) {
    state = <DateTime>{...state, ...map};
  }
}

/// Provider of list of dates at which there are exist archived services
/// in all [WorkerProfile]s, if list is empty, it will try to reinitialize all
/// underlying lists by calling [JournalHiveRepository.updateDatesInArchiveOfProfile] for each.
///
/// (aggregate from [controllerDatesInArchive]).
///
/// {@category Providers}
/// {@category Controllers}
final initDatesInAllArchives = FutureProvider((ref) async {
  Future<void> initControllers() async {
    await Future.wait([
      ...ref.watch(departmentsProvider).map((e) async =>
          ref.watch(controllerDatesInArchive(e.apiKey).notifier)._initialize()),
    ]);
  }

  if (ref.watch(datesInAllArchives).isEmpty) {
    await Future.wait(ref.read(departmentsProvider).map((e) async =>
        ref.read(e.journalOf).hiveRepository.updateDatesInArchiveOfProfile()));
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
        .watch(departmentsProvider)
        .map((e) => ref.watch(controllerDatesInArchive(e.apiKey)))
        .expand((list) => list),
  };
});

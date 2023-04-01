import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Controller for list of dates at which there are exist archived services
/// (aggregate from [datesInArchiveOfProfile]).
///
/// {@category Providers}
/// {@category Controllers}
final datesInArchiveController = Provider<_DateListController>((ref) {
  return _DateListController(ref); //..datesInited();
});

/// Dates at which there are exist archived services (aggregate from
/// [datesInArchiveOfProfile]).
///
/// {@category Providers}
final datesInArchive = Provider<List<DateTime>>((ref) {
  return <DateTime>{
    ...ref
        .watch(workerProfiles)
        .map((e) => ref.watch(datesInArchiveOfProfile(e.apiKey)))
        .reduce((value, element) => value.addAll(element) as List<DateTime>),
  }.toList();
});

final _datesInArchiveInited = FutureProvider((ref) async {
  await Future.wait([
    ...ref.watch(workerProfiles).map((e) async =>
        ref.watch(datesInArchiveOfProfile(e.apiKey).notifier).inited()),
  ]);

  return ref
      .watch(workerProfiles)
      .map((e) => ref.watch(datesInArchiveOfProfile(e.apiKey)))
      .reduce((value, element) => value.addAll(element) as List<DateTime>);
});

/// Dates at which where exist archived services in [WorkerProfile].
/// Depend on [hiveDateTimeBox] ('allArchiveDates').
///
/// {@category Providers}
final datesInArchiveOfProfile =
    StateNotifierProvider.family<_ControllerDatesInArchive, List<DateTime>, String>(
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
  Future<void>? _save;

  Future<List<DateTime>> inited() async {
    await ref.read(hiveDateTimeBox(hiveName).future);
    // log.info(state);

    return state;
  }

  /// Future for await save.
  Future<void> save() async {
    if (_save != null) {
      await _save;
      _save = null;
    }
  }

  @override
  set state(List<DateTime> value) {
    super.state = [...value];
    //
    // > save
    //
    _save = () async {
      await ref.read(hiveDateTimeBox(hiveName).future);
      final box = ref.read(hiveDateTimeBox(hiveName)).value;
      // await box!.clear();
      await box?.compact();
      await box?.addAll(value);
    }();
  }

  void addAll(Iterable<DateTime> map) {
    state = <DateTime>{...state, ...map}.toList();
  }
}

/// Controller for list of dates at which there are exist archived services
/// (aggregate from [datesInArchiveOfProfile]).
///
/// Hidden, to get reference use [datesInArchiveController] provider.
///
/// {@category Controllers}
class _DateListController {
  _DateListController(this.ref) {
    datesInited();
  }

  final ProviderRef ref;

  Future<void> save() async {
    await Future.wait(ref.read(workerProfiles).map(
          (e) => ref.read(datesInArchiveOfProfile(e.apiKey).notifier).save(),
        ));
  }

  Future<List<DateTime>> datesInited() async {
    await ref.read(_datesInArchiveInited.future);
    if (ref.read(_datesInArchiveInited).value!.isEmpty) {
      await Future.wait(ref
          .read(workerProfiles)
          .map((e) async => e.journal.updateDatesInArchiveOfProfile()));
      await ref.read(_datesInArchiveInited.future);
    }

    return ref.read(_datesInArchiveInited).value!;
  }

  List<DateTime> get dates => <DateTime>{
        ...ref
            .read(workerProfiles)
            .map((e) => ref.read(datesInArchiveOfProfile(e.apiKey)))
            .reduce(
              (value, element) => value.addAll(element) as List<DateTime>,
            ),
      }.toList();
}

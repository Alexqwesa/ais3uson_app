import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'days_with_services.g.dart';

/// Dates at which where exist archived services in [Worker].
/// Depend on [hiveDateTimeBox] .
///
/// {@category Providers}
@Riverpod(keepAlive: true)
class DaysWithServices extends _$DaysWithServices {
  // todo: use MultiSet
  String get name => 'allArchiveDates_$apiKey';
  final preInit = <DateTime>{};
  bool init = false;

  Future<Box<DateTime>> future() async =>
      await ref.watch(hiveDateTimeBox(name).future);

  @override
  Set<DateTime> build(String apiKey) {
    return ref.watch(hiveDateTimeBox(name)).when(
        data: (data) {
          init = true;
          return <DateTime>{...data.values, ...preInit};
        },
        error: (o, s) {
          return <DateTime>{};
        },
        loading: () => <DateTime>{});
  }

  /// For tests and internal use only.
  Future<void> save([Box<DateTime>? _]) async {
    await ref.watch(hiveDateTimeBox(name).future);
    final hiveBox = ref.watch(hiveDateTimeBox(name)).requireValue;
    await hiveBox.clear();
    await hiveBox.addAll(state);
  }

  @override
  set state(Set<DateTime> value) {
    if (init) {
      super.state = {...value};
      ref.watch(hiveDateTimeBox(name)).whenData(save);
    } else {
      super.state = {...value};
      preInit
        ..clear()
        ..addAll(value);
    }
  }

  void addAll(Iterable<DateTime> map) {
    state = <DateTime>{...state, ...map};
  }
}

/// Wait for [AllDaysWithServices].future() and return [AllDaysWithServices].
///
/// {@category Providers}
final allDaysWithServicesInited = FutureProvider((ref) async {
  await ref.watch(allDaysWithServicesProvider.notifier).future();

  return ref.watch(allDaysWithServicesProvider);
});

/// Dates at which there are exist archived services (aggregate from
/// [daysWithServicesProvider]) for each [Worker].
///
/// {@category Providers}
@Riverpod(keepAlive: true)
class AllDaysWithServices extends _$AllDaysWithServices {
  /// Future where all underlying providers initialized.
  Future<List<Box<DateTime>>> future() async {
    await Future.wait([
      ...ref
          .watch(departmentsProvider)
          .map((e) async => e.journalOf.hiveRepository.future()),
    ]);
    return Future.wait([
      ...ref.watch(departmentsProvider).map((e) async =>
          ref.watch(daysWithServicesProvider(e.apiKey).notifier).future()),
    ]);
  }

  @override
  Set<DateTime> build() {
    return <DateTime>{
      ...ref
          .watch(departmentsProvider)
          .map((e) => ref.watch(daysWithServicesProvider(e.apiKey)))
          .expand((list) => list),
    };
  }
}

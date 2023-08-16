// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$departmentsHash() => r'64c894188ca0343f2c1fe503ab1266dcbbf32ce3';

/// Provider and controller of List<[WorkerProfile]>.
///
/// Add, save, delete and load [WorkerProfile].
/// which are saved by [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category Controllers}
///
/// Copied from [Departments].
@ProviderFor(Departments)
final departmentsProvider =
    NotifierProvider<Departments, List<WorkerProfile>>.internal(
  Departments.new,
  name: r'departmentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$departmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Departments = Notifier<List<WorkerProfile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

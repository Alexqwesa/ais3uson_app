// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departments.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$departmentsHash() => r'53e474e4acdfd741ddec3d6c0311d9b7d4f13c30';

/// Provider and controller of List<[Worker]>.
///
/// Add, save, delete and load [Worker].
/// which are saved by [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category Controllers}
///
/// Copied from [Departments].
@ProviderFor(Departments)
final departmentsProvider =
    NotifierProvider<Departments, List<Worker>>.internal(
  Departments.new,
  name: r'departmentsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$departmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Departments = Notifier<List<Worker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

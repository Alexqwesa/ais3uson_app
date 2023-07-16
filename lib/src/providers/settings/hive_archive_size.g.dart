// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_archive_size.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiveArchiveSizeHash() => r'2afb78c596388694d4cf7966d045ae2652043e8d';

/// Provider of setting - max amount of entries stored in [Journal].
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
/// {@category Journal}
///
/// Copied from [HiveArchiveSize].
@ProviderFor(HiveArchiveSize)
final hiveArchiveSizeProvider =
    AutoDisposeNotifierProvider<HiveArchiveSize, int>.internal(
  HiveArchiveSize.new,
  name: r'hiveArchiveSizeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hiveArchiveSizeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HiveArchiveSize = AutoDisposeNotifier<int>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions

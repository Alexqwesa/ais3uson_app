// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_magnification.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tileMagnificationHash() => r'1e3d90083d9cb095ae726ce5ad4f2a71e220e5d1';

/// Provider of setting - Magnification of tiles in list of services.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
///
/// Copied from [TileMagnification].
@ProviderFor(TileMagnification)
final tileMagnificationProvider =
    NotifierProvider<TileMagnification, double>.internal(
  TileMagnification.new,
  name: r'tileMagnificationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tileMagnificationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TileMagnification = Notifier<double>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_magnification.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tileMagnificationHash() => r'd1c56a84372ab397915bd68df8f24cac4419069c';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

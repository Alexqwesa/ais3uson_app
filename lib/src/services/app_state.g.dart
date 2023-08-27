// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appStateIsHash() => r'8c7ac9bf6e14ba4a8328b4c29c8779be23add50f';

/// Global state of App:
///
/// - Archive view or usual view of App?,
/// - show archive at which day?,
/// - or show all.
///
/// {@category Providers}
/// {@category App State}
///
/// Copied from [AppStateIs].
@ProviderFor(AppStateIs)
final appStateIsProvider = NotifierProvider<AppStateIs, AppState>.internal(
  AppStateIs.new,
  name: r'appStateIsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStateIsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppStateIs = Notifier<AppState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

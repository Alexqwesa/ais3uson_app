// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appStateHash() => r'1ef97cde10e84f9f6b5c4ab878e00688d1bdf2c7';

/// Global state of App:
///
/// - Archive view or usual view of App?,
/// - show archive at which day?,
/// - or show all.
///
/// {@category Providers}
/// {@category App State}
///
/// Copied from [appState].
@ProviderFor(appState)
final appStateProvider = NotifierProvider<appState, AppState>.internal(
  appState.new,
  name: r'appStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$appState = Notifier<AppState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

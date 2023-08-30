// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appStateHash() => r'638b25d5c8b3612ae772d1e4c603e7057735e873';

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

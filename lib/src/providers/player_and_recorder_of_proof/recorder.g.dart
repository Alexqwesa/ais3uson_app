// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recorderHash() => r'3a0b7a562a07e5f48418fef91f24980c5b1e5baa';

/// Global audio recorder .
///
/// Used to record audio proofs of services.
/// {@category Providers}
/// {@category Controllers}
/// {@category UI Proofs}
///
/// Copied from [Recorder].
@ProviderFor(Recorder)
final recorderProvider = NotifierProvider<Recorder, RecorderState>.internal(
  Recorder.new,
  name: r'recorderProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recorderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Recorder = Notifier<RecorderState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalsHash() => r'2551451d4954752241cf2370d7826274dfd24013';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$Journals extends BuildlessAutoDisposeNotifier<Journal> {
  late final String apiKey;

  Journal build(
    String apiKey,
  );
}

/// Provider of [Journal] for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [Journals].
@ProviderFor(Journals)
const journalsProvider = JournalsFamily();

/// Provider of [Journal] for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [Journals].
class JournalsFamily extends Family<Journal> {
  /// Provider of [Journal] for [Worker].
  ///
  /// It check is update needed, and auto update list.
  /// Return List<[ClientPlan]>.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [Journals].
  const JournalsFamily();

  /// Provider of [Journal] for [Worker].
  ///
  /// It check is update needed, and auto update list.
  /// Return List<[ClientPlan]>.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [Journals].
  JournalsProvider call(
    String apiKey,
  ) {
    return JournalsProvider(
      apiKey,
    );
  }

  @override
  JournalsProvider getProviderOverride(
    covariant JournalsProvider provider,
  ) {
    return call(
      provider.apiKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journalsProvider';
}

/// Provider of [Journal] for [Worker].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
///
/// {@category Providers}
/// {@category Journal}
///
/// Copied from [Journals].
class JournalsProvider
    extends AutoDisposeNotifierProviderImpl<Journals, Journal> {
  /// Provider of [Journal] for [Worker].
  ///
  /// It check is update needed, and auto update list.
  /// Return List<[ClientPlan]>.
  ///
  /// {@category Providers}
  /// {@category Journal}
  ///
  /// Copied from [Journals].
  JournalsProvider(
    this.apiKey,
  ) : super.internal(
          () => Journals()..apiKey = apiKey,
          from: journalsProvider,
          name: r'journalsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalsHash,
          dependencies: JournalsFamily._dependencies,
          allTransitiveDependencies: JournalsFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is JournalsProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Journal runNotifierBuild(
    covariant Journals notifier,
  ) {
    return notifier.build(
      apiKey,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

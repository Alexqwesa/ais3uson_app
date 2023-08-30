// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalHash() => r'686e07add9537bfa54868163db5022ae20446b1a';

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

typedef JournalRef = ProviderRef<Journal>;

/// See also [journal].
@ProviderFor(journal)
const journalProvider = JournalFamily();

/// See also [journal].
class JournalFamily extends Family<Journal> {
  /// See also [journal].
  const JournalFamily();

  /// See also [journal].
  JournalProvider call(
    String apiKey,
  ) {
    return JournalProvider(
      apiKey,
    );
  }

  @override
  JournalProvider getProviderOverride(
    covariant JournalProvider provider,
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
  String? get name => r'journalProvider';
}

/// See also [journal].
class JournalProvider extends Provider<Journal> {
  /// See also [journal].
  JournalProvider(
    this.apiKey,
  ) : super.internal(
          (ref) => journal(
            ref,
            apiKey,
          ),
          from: journalProvider,
          name: r'journalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalHash,
          dependencies: JournalFamily._dependencies,
          allTransitiveDependencies: JournalFamily._allTransitiveDependencies,
        );

  final String apiKey;

  @override
  bool operator ==(Object other) {
    return other is JournalProvider && other.apiKey == apiKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

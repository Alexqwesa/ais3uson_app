// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientHash() => r'60cf1d3053a6e81e31ac51154368711a3949627d';

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

abstract class _$Client extends BuildlessNotifier<ClientState> {
  late final String apiKey;
  late final ClientEntry entry;

  ClientState build({
    required String apiKey,
    required ClientEntry entry,
  });
}

/// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
///
/// {@category Data Models Logic}
///
/// Copied from [Client].
@ProviderFor(Client)
const clientProvider = ClientFamily();

/// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
///
/// {@category Data Models Logic}
///
/// Copied from [Client].
class ClientFamily extends Family<ClientState> {
  /// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [Client].
  const ClientFamily();

  /// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [Client].
  ClientProvider call({
    required String apiKey,
    required ClientEntry entry,
  }) {
    return ClientProvider(
      apiKey: apiKey,
      entry: entry,
    );
  }

  @override
  ClientProvider getProviderOverride(
    covariant ClientProvider provider,
  ) {
    return call(
      apiKey: provider.apiKey,
      entry: provider.entry,
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
  String? get name => r'clientProvider';
}

/// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
///
/// {@category Data Models Logic}
///
/// Copied from [Client].
class ClientProvider extends NotifierProviderImpl<Client, ClientState> {
  /// Provider of [ClientState], which store List<[ClientService]> and [ClientEntry].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [Client].
  ClientProvider({
    required this.apiKey,
    required this.entry,
  }) : super.internal(
          () => Client()
            ..apiKey = apiKey
            ..entry = entry,
          from: clientProvider,
          name: r'clientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clientHash,
          dependencies: ClientFamily._dependencies,
          allTransitiveDependencies: ClientFamily._allTransitiveDependencies,
        );

  final String apiKey;
  final ClientEntry entry;

  @override
  bool operator ==(Object other) {
    return other is ClientProvider &&
        other.apiKey == apiKey &&
        other.entry == entry;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);
    hash = _SystemHash.combine(hash, entry.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  ClientState runNotifierBuild(
    covariant Client notifier,
  ) {
    return notifier.build(
      apiKey: apiKey,
      entry: entry,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

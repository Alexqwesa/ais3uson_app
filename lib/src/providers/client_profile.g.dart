// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_profile.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientProfileHash() => r'aad725dca4e514d287059c0c81692e86922c733e';

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

abstract class _$ClientProfile extends BuildlessNotifier<ClientEntry> {
  late final String apiKey;
  late final ClientEntry entry;

  ClientEntry build({
    required String apiKey,
    required ClientEntry entry,
  });
}

/// Extension of [ClientProfile] with providers:
/// [servicesOf] - provider of list of [ClientService].
///
/// {@category Data Models Logic}
///
/// Copied from [ClientProfile].
@ProviderFor(ClientProfile)
const clientProfileProvider = ClientProfileFamily();

/// Extension of [ClientProfile] with providers:
/// [servicesOf] - provider of list of [ClientService].
///
/// {@category Data Models Logic}
///
/// Copied from [ClientProfile].
class ClientProfileFamily extends Family<ClientEntry> {
  /// Extension of [ClientProfile] with providers:
  /// [servicesOf] - provider of list of [ClientService].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [ClientProfile].
  const ClientProfileFamily();

  /// Extension of [ClientProfile] with providers:
  /// [servicesOf] - provider of list of [ClientService].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [ClientProfile].
  ClientProfileProvider call({
    required String apiKey,
    required ClientEntry entry,
  }) {
    return ClientProfileProvider(
      apiKey: apiKey,
      entry: entry,
    );
  }

  @override
  ClientProfileProvider getProviderOverride(
    covariant ClientProfileProvider provider,
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
  String? get name => r'clientProfileProvider';
}

/// Extension of [ClientProfile] with providers:
/// [servicesOf] - provider of list of [ClientService].
///
/// {@category Data Models Logic}
///
/// Copied from [ClientProfile].
class ClientProfileProvider
    extends NotifierProviderImpl<ClientProfile, ClientEntry> {
  /// Extension of [ClientProfile] with providers:
  /// [servicesOf] - provider of list of [ClientService].
  ///
  /// {@category Data Models Logic}
  ///
  /// Copied from [ClientProfile].
  ClientProfileProvider({
    required this.apiKey,
    required this.entry,
  }) : super.internal(
          () => ClientProfile()
            ..apiKey = apiKey
            ..entry = entry,
          from: clientProfileProvider,
          name: r'clientProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clientProfileHash,
          dependencies: ClientProfileFamily._dependencies,
          allTransitiveDependencies:
              ClientProfileFamily._allTransitiveDependencies,
        );

  final String apiKey;
  final ClientEntry entry;

  @override
  bool operator ==(Object other) {
    return other is ClientProfileProvider &&
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
  ClientEntry runNotifierBuild(
    covariant ClientProfile notifier,
  ) {
    return notifier.build(
      apiKey: apiKey,
      entry: entry,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_http.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$repositoryHttpHash() => r'53ea5d86c0ed79a12134410332eddd1b4c1d419c';

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

typedef RepositoryHttpRef = AutoDisposeProviderRef<Http>;

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
///
/// Copied from [repositoryHttp].
@ProviderFor(repositoryHttp)
const repositoryHttpProvider = RepositoryHttpFamily();

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
///
/// Copied from [repositoryHttp].
class RepositoryHttpFamily extends Family<Http> {
  /// Provider of httpData, create families by apiKey and url.
  ///
  /// {@category Providers}
  ///
  /// Copied from [repositoryHttp].
  const RepositoryHttpFamily();

  /// Provider of httpData, create families by apiKey and url.
  ///
  /// {@category Providers}
  ///
  /// Copied from [repositoryHttp].
  RepositoryHttpProvider call(
    Tuple2<WorkerKey, String> apiUrl,
  ) {
    return RepositoryHttpProvider(
      apiUrl,
    );
  }

  @override
  RepositoryHttpProvider getProviderOverride(
    covariant RepositoryHttpProvider provider,
  ) {
    return call(
      provider.apiUrl,
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
  String? get name => r'repositoryHttpProvider';
}

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
///
/// Copied from [repositoryHttp].
class RepositoryHttpProvider extends AutoDisposeProvider<Http> {
  /// Provider of httpData, create families by apiKey and url.
  ///
  /// {@category Providers}
  ///
  /// Copied from [repositoryHttp].
  RepositoryHttpProvider(
    this.apiUrl,
  ) : super.internal(
          (ref) => repositoryHttp(
            ref,
            apiUrl,
          ),
          from: repositoryHttpProvider,
          name: r'repositoryHttpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$repositoryHttpHash,
          dependencies: RepositoryHttpFamily._dependencies,
          allTransitiveDependencies:
              RepositoryHttpFamily._allTransitiveDependencies,
        );

  final Tuple2<WorkerKey, String> apiUrl;

  @override
  bool operator ==(Object other) {
    return other is RepositoryHttpProvider && other.apiUrl == apiUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$httpHash() => r'70eb4a4999649f4f4b760bf3df7a6cc4f500b9a3';

abstract class _$Http
    extends BuildlessAutoDisposeNotifier<List<Map<String, dynamic>>> {
  late final String apiKey;
  late final String path;

  List<Map<String, dynamic>> build(
    String apiKey,
    String path,
  );
}

/// Repository for families of providers [repositoryHttp].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
///
/// {@category Providers}
///
/// Copied from [Http].
@ProviderFor(Http)
const httpProvider = HttpFamily();

/// Repository for families of providers [repositoryHttp].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
///
/// {@category Providers}
///
/// Copied from [Http].
class HttpFamily extends Family<List<Map<String, dynamic>>> {
  /// Repository for families of providers [repositoryHttp].
  ///
  /// Read hive on init, [state] is a [http.Response] in json format,
  ///  save state to [Hive].
  ///
  /// Public methods [getHttpData] and [syncHiveHttp].
  ///
  /// {@category Providers}
  ///
  /// Copied from [Http].
  const HttpFamily();

  /// Repository for families of providers [repositoryHttp].
  ///
  /// Read hive on init, [state] is a [http.Response] in json format,
  ///  save state to [Hive].
  ///
  /// Public methods [getHttpData] and [syncHiveHttp].
  ///
  /// {@category Providers}
  ///
  /// Copied from [Http].
  HttpProvider call(
    String apiKey,
    String path,
  ) {
    return HttpProvider(
      apiKey,
      path,
    );
  }

  @override
  HttpProvider getProviderOverride(
    covariant HttpProvider provider,
  ) {
    return call(
      provider.apiKey,
      provider.path,
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
  String? get name => r'httpProvider';
}

/// Repository for families of providers [repositoryHttp].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
///
/// {@category Providers}
///
/// Copied from [Http].
class HttpProvider
    extends AutoDisposeNotifierProviderImpl<Http, List<Map<String, dynamic>>> {
  /// Repository for families of providers [repositoryHttp].
  ///
  /// Read hive on init, [state] is a [http.Response] in json format,
  ///  save state to [Hive].
  ///
  /// Public methods [getHttpData] and [syncHiveHttp].
  ///
  /// {@category Providers}
  ///
  /// Copied from [Http].
  HttpProvider(
    this.apiKey,
    this.path,
  ) : super.internal(
          () => Http()
            ..apiKey = apiKey
            ..path = path,
          from: httpProvider,
          name: r'httpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$httpHash,
          dependencies: HttpFamily._dependencies,
          allTransitiveDependencies: HttpFamily._allTransitiveDependencies,
        );

  final String apiKey;
  final String path;

  @override
  bool operator ==(Object other) {
    return other is HttpProvider &&
        other.apiKey == apiKey &&
        other.path == path;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, apiKey.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  List<Map<String, dynamic>> runNotifierBuild(
    covariant Http notifier,
  ) {
    return notifier.build(
      apiKey,
      path,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

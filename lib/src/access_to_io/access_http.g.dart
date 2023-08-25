// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_http.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpHash() => r'1736a56219f83279aa319e701d53f44028037bd9';

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

abstract class _$Http extends BuildlessNotifier<List<Map<String, dynamic>>> {
  late final String apiKey;
  late final String path;

  List<Map<String, dynamic>> build(
    String apiKey,
    String path,
  );
}

/// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
///
/// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
///
/// Read hive on init, [state] is a List from json [http.Response] ,
///  save state to [Hive].
/// {@category Providers}
///
/// Copied from [Http].
@ProviderFor(Http)
const httpProvider = HttpFamily();

/// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
///
/// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
///
/// Read hive on init, [state] is a List from json [http.Response] ,
///  save state to [Hive].
/// {@category Providers}
///
/// Copied from [Http].
class HttpFamily extends Family<List<Map<String, dynamic>>> {
  /// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
  ///
  /// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
  ///
  /// Read hive on init, [state] is a List from json [http.Response] ,
  ///  save state to [Hive].
  /// {@category Providers}
  ///
  /// Copied from [Http].
  const HttpFamily();

  /// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
  ///
  /// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
  ///
  /// Read hive on init, [state] is a List from json [http.Response] ,
  ///  save state to [Hive].
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

/// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
///
/// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
///
/// Read hive on init, [state] is a List from json [http.Response] ,
///  save state to [Hive].
/// {@category Providers}
///
/// Copied from [Http].
class HttpProvider
    extends NotifierProviderImpl<Http, List<Map<String, dynamic>>> {
  /// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
  ///
  /// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
  ///
  /// Read hive on init, [state] is a List from json [http.Response] ,
  ///  save state to [Hive].
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

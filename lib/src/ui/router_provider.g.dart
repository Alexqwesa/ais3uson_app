// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routeHash() => r'123472c3cbd7eae3dbf72fe6c68d26eafb0cab13';

/// See also [route].
@ProviderFor(route)
final routeProvider = AutoDisposeProvider<GoRouter>.internal(
  route,
  name: r'routeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouteRef = AutoDisposeProviderRef<GoRouter>;
String _$routerHash() => r'5d7fc9e6e3d97fc87f6f8e70b7ef6225c0598b99';

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

typedef RouterRef = ProviderRef<GoRouter>;

/// See also [router].
@ProviderFor(router)
const routerProvider = RouterFamily();

/// See also [router].
class RouterFamily extends Family<GoRouter> {
  /// See also [router].
  const RouterFamily();

  /// See also [router].
  RouterProvider call(
    String? initialLocation,
  ) {
    return RouterProvider(
      initialLocation,
    );
  }

  @override
  RouterProvider getProviderOverride(
    covariant RouterProvider provider,
  ) {
    return call(
      provider.initialLocation,
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
  String? get name => r'routerProvider';
}

/// See also [router].
class RouterProvider extends Provider<GoRouter> {
  /// See also [router].
  RouterProvider(
    this.initialLocation,
  ) : super.internal(
          (ref) => router(
            ref,
            initialLocation,
          ),
          from: routerProvider,
          name: r'routerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routerHash,
          dependencies: RouterFamily._dependencies,
          allTransitiveDependencies: RouterFamily._allTransitiveDependencies,
        );

  final String? initialLocation;

  @override
  bool operator ==(Object other) {
    return other is RouterProvider && other.initialLocation == initialLocation;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialLocation.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

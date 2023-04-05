// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Stub provider of current service. Separate from [lastUsed] for overriding.
final currentService = Provider<ClientService>(
  (ref) => ref.watch(lastUsed).service,
);

/// Provider of current size of container of services.
final currentSizeOfParentForListOfServices =
    StateNotifierProvider<_ServiceContainerSizeState, Size>((ref) {
  return _ServiceContainerSizeState(ref);
});

/// Last searched text by user.
///
/// {@category Providers}
// {@category App State}
final currentSearchText = StateNotifierProvider<_CurrentSearch, String>((ref) {
  return _CurrentSearch();
});

class _CurrentSearch extends StateNotifier<String> {
  _CurrentSearch() : super('');

  @override
  set state(String value) {
    super.state = value;
  }
}

class _ServiceContainerSizeState extends StateNotifier<Size> {
  _ServiceContainerSizeState(this.ref) : super(const Size(100, 100));

  final Ref ref;

  @override
  Size get state => super.state;

  @override
  set state(Size value) {
    super.state = value;
  }

  Future<void> delayedChange(Size value) async {
    ref.read(_sizeHelper.notifier).state = value;
    Future.delayed(const Duration(milliseconds: 1000), () {
      final size = ref.read(_sizeHelper);
      if (value.width == size.width && value.height == size.height) {
        super.state = value;
      }
    });
  }
}

/// Provider of current size of container of services.
final _sizeHelper = StateNotifierProvider<__SizeHelper, Size>((ref) {
  return __SizeHelper();
});

class __SizeHelper extends StateNotifier<Size> {
  __SizeHelper() : super(const Size(100, 100));
}

/// List of services of client filtered by [currentSearchText].
final filteredServices =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final searched = ref.watch(currentSearchText).toLowerCase();
  final servList = ref
      .watch(client.servicesOf)
      .where((element) => element.servText.toLowerCase().contains(searched))
      .toList(growable: false);

  return servList;
});

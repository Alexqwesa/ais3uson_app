// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Stub provider of current service. Separate from [lastUsed] for overriding.
final currentService = Provider<ClientService>(
  (ref) => ref.watch(lastUsed).service,
);

/// Provider of current size of container of services.
final currentServiceContainerSize =
    StateNotifierProvider<_ServiceContainerSizeState, Size>((ref) {
  return _ServiceContainerSizeState(ref.read);
});

class _ServiceContainerSizeState extends StateNotifier<Size> {
  _ServiceContainerSizeState(this.read) : super(const Size(100, 100));

  Reader read;

  Future<void> delayedChange(Size value) async {
    read(_sizeHelper.notifier).state = value;
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (value.width == read(_sizeHelper).width &&
          value.height == read(_sizeHelper).height) {
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

/// Stub provider of current size of container of services.
final currentSearch = StateNotifierProvider<_CurrentSearch, String>((ref) {
  return _CurrentSearch();
});

class _CurrentSearch extends StateNotifier<String> {
  _CurrentSearch() : super('');

  @override
  set state(String value) {
    super.state = value;
  }
}

/// List of services of client filtered by currentSearch.
final filteredServices =
    Provider.family<List<ClientService>, ClientProfile>((ref, client) {
  final search = ref.watch(currentSearch).toLowerCase();
  final servList = ref
      .watch(servicesOfClient(client))
      .where((element) => element.servText.toLowerCase().contains(search))
      .toList(growable: false);

  return servList;
});

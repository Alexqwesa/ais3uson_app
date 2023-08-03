// ignore_for_file: unnecessary_import

import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Stub provider of current service. Separate from [lastUsed] for overriding.
final currentService = Provider<ClientService>(
  (ref) => ref.watch(lastUsed).service,
);

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

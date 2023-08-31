// ignore_for_file: sort_constructors_first

import 'dart:convert';
import 'dart:math';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'worker_keys.g.dart';

const workerKeysInSharedPref = 'WorkerKeys2';

/// Provider and controller of List<[WorkerKey]>.
///
/// Add, delete, save and load [WorkerKey]s.
/// (They are saved in [SharedPreferences])
///
/// {@category Providers}
///
/// {@category Controllers}
@Riverpod(keepAlive: true)
WorkerKeysState workerKeys(Ref ref) {
  final json = jsonDecode(
    locator<SharedPreferences>().getString(workerKeysInSharedPref) ?? '[]',
  );
  var keys = <WorkerKey>[];
  if (json is List) {
    keys = json
        .whereType<Map<String, dynamic>>()
        .map<WorkerKey>(WorkerKey.fromJson)
        .toList(growable: false);
  }
  return WorkerKeysState(ref: ref, keys: keys);
}

class WorkerKeysState {
  final List<WorkerKey> keys;

  /// Prebuilt list from keys
  final List<String> apiKeys;

  /// Prebuilt list from keys
  final List<String> aliases;

  final Ref ref;

  WorkerKeysState({required this.ref, required List<WorkerKey> keys})
      : keys = UnmodifiableListView(keys),
        aliases = UnmodifiableListView(_generateAliases(keys)),
        apiKeys = UnmodifiableListView(keys.map((e) => e.apiKey));

  Worker get firstWorker =>
      ref.watch(workerProvider(keys.first.apiKey).notifier);

  List<Worker> get workers =>
      [for (final key in keys) ref.watch(workerProvider(key.apiKey).notifier)];

  int get length => keys.length;

  WorkerKey get first => keys.first;

  WorkerKey get last => keys.last;

  WorkerKey byAlias(String? alias) {
    if (alias == null) return stubWorkerKey;

    final index = aliases.indexOf(alias);
    if (index >= 0) {
      return keys[index];
    }
    return stubWorkerKey;
  }

  WorkerKey byApiKey(String apiKey) {
    final index = apiKeys.indexOf(apiKey);
    if (index >= 0) {
      return keys[index];
    }
    return stubWorkerKey;
  }

  WorkerKey operator [](String? alias) => byAlias(alias);

  static List<String> _generateAliases(List<WorkerKey> keys, {int length = 7}) {
    var shortNames = [
      for (final wk in keys)
        wk.apiKey.hashCode
            .toString()
            .substring(0, min(length, wk.apiKey.hashCode.toString().length))
    ];
    if (shortNames.length != shortNames.toSet().length) {
      if (length > 9) {
        shortNames = [for (final wk in keys) wk.apiKey];
        return shortNames;
      }
      _generateAliases(keys, length: length + 2);
    }
    return shortNames;
  }

  Future<bool> add(WorkerKey key) async {
    if (!apiKeys.contains(key.apiKey)) {
      final newKeys = [...keys, key];
      return _save(newKeys);
    }

    return false;
  }

  Future<bool> delete(WorkerKey key) async {
    if (apiKeys.contains(key.apiKey)) {
      return _save(keys.whereNot((e) => e.apiKey == key.apiKey));
    }
    return false;
  }

  Future<bool> _save(Iterable<WorkerKey> newKeys) async {
    final saved = await locator<SharedPreferences>().setString(
        workerKeysInSharedPref,
        jsonEncode(newKeys.map((e) => e.toJson()).toList()));
    if (!saved) {
      showErrorNotification(tr().errorDepSave);
    }

    ref.invalidate(workerKeysProvider);
    return saved;
  }

  Iterable<T> Function<T>(T Function(WorkerKey e) toElement) get map =>
      keys.map;
}

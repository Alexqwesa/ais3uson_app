// ignore_for_file: always_use_package_imports, prefer_final_fields, flutter_style_todos
import 'dart:async';
import 'dart:developer' as dev;

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/sync_mixin/sync_data_mixin.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Basic data about client:
/// - [name],
/// - [contractId],
/// - [services] - list of [ClientService],
/// - reference to worker (of type [WorkerProfile]) assigned to this client.
///
/// {@category Data_Classes}
// ignore: prefer_mixin
class ClientProfile with ChangeNotifier, SyncDataMixin {
  late WorkerProfile workerProfile;
  late ClientEntry entry;

  @override
  String get apiKey => workerProfile.apiKey;

  int get contractId => entry.contractId;

  String get name => entry.client;

  String get contract => entry.contract;

  /// return List of [ClientService]s
  ///
  /// if list empty - try to fill it here,
  /// if error - just return empty
  List<ClientService> get services => _services;

  List<ClientService> _services = [];

  /// Init and subscribe to events from [WorkerProfile],
  /// because it is the class that get actual data.
  ClientProfile({
    required this.workerProfile,
    required this.entry,
  }) {
    workerProfile.addListener(updateServices);
  }

  /// Stub.
  @override
  void updateValueFromHive(
    String hiveKey,
    Box hive, {
    bool onlyIfEmpty = false,
  }) {
    return; // just stub
  }

  /// Get data from [WorkerProfile] and filter only needed.
  ///
  /// This is a receiver of events from [WorkerProfile].
  Future<void> updateServices() async {
    try {
      //
      // > just search through lists to prepare list of [ClientService]
      //
      final wp = workerProfile;
      _services = wp.clientPlan.where((element) {
        return element.contractId == contractId &&
            wp.services.map((e) => e.id).contains(element.servId);
      }).map((e) {
        return ClientService(
          service: wp.services.firstWhere((serv) => serv.id == e.servId),
          planned: wp.clientPlan.firstWhere((plan) => plan.servId == e.servId),
          journal: wp.journal,
          workerDepId: wp.key.workerDepId,
        );
      }).toList(growable: true);
      notifyListeners();
      // ignore: avoid_catching_errors
    } on StateError catch (e) {
      if (e.message == 'No element') {
        await workerProfile.checkAllServicesExist();
        showErrorNotification(
          'Ошибка: не удалось подготовить список услуг! $e',
        );
      }
      dev.log('ClientProfile: get services: ${e.message}');
    }
  }
}

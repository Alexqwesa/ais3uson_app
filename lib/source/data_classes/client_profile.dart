// ignore_for_file: always_use_package_imports, prefer_final_fields, flutter_style_todos
import 'dart:developer' as dev;

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/sync_mixin/sync_data_mixin.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/material.dart';

/// Basic data about client:
/// - [name],
/// - [contractId],
/// - [services] - list of [ClientService],
/// - reference to worker (of type [WorkerProfile]) assigned to this client.
// ignore: prefer_mixin
class ClientProfile with ChangeNotifier, SyncDataMixin {
  late int contractId;
  late String name;
  late WorkerProfile workerProfile;

  /// return List of [ClientService]s
  ///
  /// if list empty - try to fill it here,
  /// if error - just return empty
  List<ClientService> get services {
    if (_services.isEmpty) {
      try {
        //
        // > just search through lists to prepare list of [ClientService]
        //
        _services = workerProfile.fioPlanned
            .where((element) => element.contractId == contractId)
            .map((e) {
          return ClientService(
            service: workerProfile.services
                .firstWhere((element) => element.id == e.servId),
            planned: workerProfile.fioPlanned
                .firstWhere((element) => element.servId == e.servId),
            journal: workerProfile.journal,
            workerDepId: workerProfile.key.workerDepId,
          );
        }).toList(growable: true);
        // ignore: avoid_catching_errors
      } on StateError catch (e) {
        if (e.message == 'No element') {
          showErrorNotification(
            'Ошибка: не удалось подготовить список услуг! $e',
          );
        }
        dev.log('ClientProfile: get services: ${e.message}');
      }
    }

    //
    // > return is here (and only here)
    //
    return _services;
  }

  // set services(List<ClientService> val) => _services = val;

  List<ClientService> _services = [];

  ClientProfile({
    required this.workerProfile,
    required this.contractId,
    required this.name,
  });

  @override
  void updateValueFromHive(String hiveKey) {
    // TODO: implement updateValueFromHive
  }
}

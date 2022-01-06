// ignore_for_file: always_use_package_imports, prefer_final_fields, flutter_style_todos

import 'package:ais3uson_app/src/data_classes/client_service.dart';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:flutter/material.dart';

/// [ClientProfile]
///
/// Basic data about client:
///                           contract,
///                           name,
///                           services,
///                           which worker is assigned
// ignore: prefer_mixin
class ClientProfile with ChangeNotifier, SyncData {
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
        // throw IterableElementError.noElement();
        // } catch(e,s) { // IterableElementError
      } on StateError catch (e) {
        showErrorNotification('Ошибка: не удалось подготовить список услуг! $e');
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

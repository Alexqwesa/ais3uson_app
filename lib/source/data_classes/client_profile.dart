// ignore_for_file: always_use_package_imports, prefer_final_fields, flutter_style_todos
import 'dart:async';
import 'dart:developer' as dev;

import 'package:ais3uson_app/source/data_classes/client_service.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/sync_mixin/sync_data_mixin.dart';
import 'package:flutter/material.dart';

/// Basic data about client:
/// - [name],
/// - [contractId],
/// - [services] - list of [ClientService],
/// - reference to worker (of type [WorkerProfile]) assigned to this client.
///
/// {@category Data_Classes}
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
      updateServices().then((value) => notifyListeners);
    }

    return _services;
  }

  List<ClientService> _services = [];

  ClientProfile({
    required this.workerProfile,
    required this.contractId,
    required this.name,
  }) {
    //
    // > since workerProfile is the one who get data - listen to this class
    //
    workerProfile.addListener(updateServices);
  }

  @override
  void updateValueFromHive(String hiveKey) {
    return; // just stub
  }

  Future<void> updateServices() async {
    try {
      //
      // > just search through lists to prepare list of [ClientService]
      //
      final wp = workerProfile;
      _services = wp.clientPlanned.where((element) {
        return element.contractId == contractId &&
            wp.services.map((e) => e.id).contains(element.servId);
      }).map((e) {
        return ClientService(
          service: wp.services.firstWhere((serv) => serv.id == e.servId),
          planned:
              wp.clientPlanned.firstWhere((plan) => plan.servId == e.servId),
          journal: wp.journal,
          workerDepId: wp.key.workerDepId,
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
}

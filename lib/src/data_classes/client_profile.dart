// ignore_for_file: always_use_package_imports, prefer_final_fields, flutter_style_todos

import 'dart:developer' as dev;

import 'package:ais3uson_app/src/data_classes/client_service.dart';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';
import 'package:ais3uson_app/src/data_classes/worker_profile.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

// ignore: prefer_mixin
class ClientProfile with ChangeNotifier, SyncData {
  late int contractId;
  late String name;
  late WorkerProfile workerProfile;

  List<ClientService> get services {
    //
    // Try to fill if empty
    //
    if (_services.isEmpty) {
      try {
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
        Future.delayed(Duration(milliseconds: 100),
        () {
          showSimpleNotification(
            const Text('Ошибка: не удалось подготовить список услуг!'),
            background: Colors.red[300],
            position: NotificationPosition.bottom,
          );
        },);

        return _services;
      }
    }

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

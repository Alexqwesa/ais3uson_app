// ignore_for_file: always_use_package_imports, prefer_final_fields

import 'package:ais3uson_app/src/data_classes/client_service.dart';
import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';

import 'from_json/fio_planned.dart';

class ClientProfile with SyncData {
  late int contractId;
  late String name;

  List<ClientService> get services => _services;

  set services(List<ClientService> val) => _services = val;

  List<ClientService> _services = [];

  ClientProfile(this.contractId, this.name);

  @override
  void updateValueFromHive(String hiveKey) {
    // TODO: implement updateValueFromHive
  }
}

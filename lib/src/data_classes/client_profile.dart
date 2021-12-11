// ignore_for_file: always_use_package_imports

import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';

import 'from_json/fio_planned.dart';

class ClientProfile with SyncData {
  late int contractId;
  late String name;

  List<FioPlanned> get services => _services;
  List<FioPlanned> _services = [];

  ClientProfile(this.contractId, this.name);
}

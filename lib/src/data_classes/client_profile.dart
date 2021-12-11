import 'package:ais3uson_app/src/data_classes/sync_mixin.dart';

import 'from_json/fio_planned.dart';

class ClientProfile with SyncData {
  late int contractId;
  late String name;

  // late Box hive;

  List<FioPlanned> _services = [];

  List<FioPlanned> get services => _services;

  ClientProfile(this.contractId, this.name);
}

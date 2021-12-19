import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/fio_planned.dart';
import 'package:ais3uson_app/src/data_classes/from_json/service_entry.dart';
import 'package:ais3uson_app/src/data_classes/journal.dart';

class ClientService {
  late final ServiceEntry service;
  late final FioPlanned planned;
  late final int workerId;
  late final int depId;

  int get contractId => planned.contractId;

  int get servId => planned.servId;

  int get plan => planned.planned;

  int get filled => planned.filled;

  int get subServ => service.subServ;

  String get servText => service.servText;

  String get servTextAdd => service.servTextAdd;

  String get shortText => service.shortText;

  int get used => _used;

  int _used = 0;



  ClientService({
    required this.service,
    required this.planned,
    required this.workerId,
    required this.depId,
  });

  bool addUsed() {
    AppData().journal.add(
          ServiceOfJournal(
            servId: planned.servId,
            contractId: planned.contractId,
            workerId: workerId,
            depId: depId,
          ),
        );

    return true;
  }
}

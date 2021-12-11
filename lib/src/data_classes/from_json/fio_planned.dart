/// contract_id : 2
/// serv_id : 1
/// planned : 10
/// filled : "None"

// ignore_for_file:invalid_assignment
// ignore_for_file:avoid_dynamic_calls

class FioPlanned {
  int get contractId => _contractId;

  int get servId => _servId;

  int get planned => _planned;

  String get filled => _filled;

  late int _contractId;
  late int _servId;
  late int _planned;
  late String _filled;

  FioPlanned({
    required int contractId,
    required int servId,
    required int planned,
    required String filled,
  }) {
    _contractId = contractId;
    _servId = servId;
    _planned = planned;
    _filled = filled;
  }

  // ignore: avoid_annotating_with_dynamic
  FioPlanned.fromJson(dynamic json) {
    _contractId = json['contract_id'];
    _servId = json['serv_id'];
    _planned = json['planned'];
    _filled = json['filled'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contract_id'] = _contractId;
    map['serv_id'] = _servId;
    map['planned'] = _planned;
    map['filled'] = _filled;

    return map;
  }
}

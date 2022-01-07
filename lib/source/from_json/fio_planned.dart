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

  int get filled => _filled;

  late int _contractId;
  late int _servId;
  late int _planned;
  late int _filled;

  FioPlanned({
    int? contractId,
    int? servId,
    int? planned,
    int? filled,
  }) {
    _contractId = contractId ?? 0;
    _servId = servId ?? 0;
    _planned = planned ?? 0;
    _filled = filled ?? 0;
  }

  // ignore: avoid_annotating_with_dynamic
  FioPlanned.fromJson(dynamic json) {
    _contractId = json['contract_id'] ?? 0;
    _servId = json['serv_id'] ?? 0;
    _planned = json['planned'] ?? 0;
    _filled = json['filled'] ?? 0;
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

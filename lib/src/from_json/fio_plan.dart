/// contract_id : 1458
/// serv_id : 145
/// planned : 1
/// filled : 0

class FioPlan {
  FioPlan({
    required int contractId,
    required int servId,
    required int planned,
    required int filled,
  }) {
    _contractId = contractId;
    _servId = servId;
    _planned = planned;
    _filled = filled;
  }

  FioPlan.fromJson(dynamic json) {
    _contractId = json['contract_id'];
    _servId = json['serv_id'];
    _planned = json['planned'];
    _filled = json['filled'];
  }

  int _contractId = 0;
  int _servId = 0;
  int _planned = 0;
  int _filled = 0;

  int get contractId => _contractId;

  int get servId => _servId;

  int get planned => _planned;

  int get filled => _filled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['contract_id'] = _contractId;
    map['serv_id'] = _servId;
    map['planned'] = _planned;
    map['filled'] = _filled;
    return map;
  }
}

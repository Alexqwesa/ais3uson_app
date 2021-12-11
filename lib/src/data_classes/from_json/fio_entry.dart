/// Autogenerated from test data
/// api_key : "123"
/// contract_id : 1
/// dep_id : 1
/// ufio_id : 1
/// contract : "12312313/2001"
/// ufio : "Тес. *. ч-ек"
/// dhw_id : 1

// ignore_for_file:invalid_assignment
// ignore_for_file:avoid_dynamic_calls

class FioEntry {
  String get apiKey => _apiKey;

  int get contractId => _contractId;

  int get depId => _depId;

  int get ufioId => _ufioId;

  String get contract => _contract;

  String get ufio => _ufio;

  int get dhwId => _dhwId;

  late String _apiKey;
  late int _contractId;
  late int _depId;
  late int _ufioId;
  late String _contract;
  late String _ufio;
  late int _dhwId;

  FioEntry({
    required String apiKey,
    required int contractId,
    required int depId,
    required int ufioId,
    required String contract,
    required String ufio,
    required int dhwId,
  }) {
    _apiKey = apiKey;
    _contractId = contractId;
    _depId = depId;
    _ufioId = ufioId;
    _contract = contract;
    _ufio = ufio;
    _dhwId = dhwId;
  }

  FioEntry.fromJson(dynamic json) {
    _apiKey = "${json['api_key']}";
    _contractId = json['contract_id'];
    _depId = json['dep_id'];
    _ufioId = json['ufio_id'];
    _contract = json['contract'] ?? 'ERROR';
    _ufio = json['ufio'] ?? 'ERROR';
    _dhwId = json['dhw_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key'] = _apiKey;
    map['contract_id'] = _contractId;
    map['dep_id'] = _depId;
    map['ufio_id'] = _ufioId;
    map['contract'] = _contract;
    map['ufio'] = _ufio;
    map['dhw_id'] = _dhwId;

    return map;
  }
}

// ignore_for_file:invalid_assignment, avoid_annotating_with_dynamic
// ignore_for_file:avoid_dynamic_calls

import 'package:flutter/material.dart';

/// Autogenerated from test data like this:
/// api_key : "123"
/// contract_id : 1
/// dep_id : 1
/// client_id : 1
/// contract : "12312313/2001"
/// client : "Тес. *. ч-ек"
/// dhw_id : 1
///
/// {@category Import_from_json}
@immutable
class ClientEntry {
  late final String _apiKey;
  late final int _contractId;
  late final int _depId;
  late final int _clientId;
  late final String _contract;
  late final String _client;
  late final int _dhwId;

  String get apiKey => _apiKey;

  int get contractId => _contractId;

  int get depId => _depId;

  int get clientId => _clientId;

  String get contract => _contract;

  String get client => _client;

  int get dhwId => _dhwId;

  ClientEntry({
    required String apiKey,
    required int contractId,
    required int depId,
    required int clientId,
    required String contract,
    required String client,
    required int dhwId,
  }) {
    _apiKey = apiKey;
    _contractId = contractId;
    _depId = depId;
    _clientId = clientId;
    _contract = contract;
    _client = client;
    _dhwId = dhwId;
  }

  ClientEntry.fromJson(dynamic json) {
    _apiKey = "${json['api_key']}";
    _contractId = json['contract_id'];
    _depId = json['dep_id'];
    _clientId = json['client_id'];
    _contract = json['contract'] ?? 'ERROR';
    _client = json['client'] ?? 'ERROR';
    _dhwId = json['dhw_id'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_key'] = _apiKey;
    map['contract_id'] = _contractId;
    map['dep_id'] = _depId;
    map['client_id'] = _clientId;
    map['contract'] = _contract;
    map['client'] = _client;
    map['dhw_id'] = _dhwId;

    return map;
  }
}
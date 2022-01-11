// import 'package:flutter/material.dart';
// ignore_for_file:invalid_assignment
// ignore_for_file:avoid_dynamic_calls

import 'package:flutter/material.dart';

/// app : "AIS3USON web"
/// name : "test"
/// worker_dep_id: 1
/// api_key : "123"
/// dep_id : 1
/// dep : "otd test"
/// db : "kcson"
/// host : "192.168.0.102"
/// port : "48080"
///
/// {@category Import_from_json}
@immutable
class WorkerKey {
  String get app => _app;

  String get name => _name;

  String get apiKey => _apiKey;

  int get workerDepId => _workerDepId;

  String get dep => _dep;

  String get db => _db;

  String get host => _host;

  String get port => _port;

  String get httpBody => '''{"api_key": $_apiKey}''';

  @override
  int get hashCode {
    return '${_apiKey.hashCode} + ${_dep.hashCode} + ${_host.hashCode}'
        .hashCode;
  }

  String _app = '';
  String _name = '';
  String _apiKey = '';
  int _workerDepId = 0;
  String _dep = '';
  String _db = '';
  String _host = '';
  String _port = '';

  WorkerKey({
    required String app,
    required String name,
    required String apiKey,
    required int workerDepId,
    required String dep,
    required String db,
    required String host,
    required String port,
  }) {
    _app = app;
    _name = name;
    _apiKey = apiKey;
    _workerDepId = workerDepId;
    _dep = dep;
    _db = db;
    _host = host;
    _port = port;
  }

  // ignore: avoid_annotating_with_dynamic
  WorkerKey.fromJson(dynamic json) {
    _app = json['app'];
    _name = json['name'];
    _apiKey = json['api_key'];
    _workerDepId = json['worker_dep_id'];
    _dep = json['dep'];
    _db = json['db'];
    _host = json['host'];
    _port = json['port'];
  }

  @override
  // ignore: avoid_annotating_with_dynamic
  bool operator ==(dynamic other) {
    if (other.runtimeType != WorkerKey) {
      return false;
    }

    // other = other as WorkerKey;
    return _app == other.app &&
        _name == other.name &&
        _apiKey == other.apiKey &&
        _workerDepId == other.workerDepId &&
        _dep == other.dep &&
        _db == other.db &&
        _host == other.host &&
        _port == other.port;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app'] = _app;
    map['name'] = _name;
    map['api_key'] = _apiKey;
    map['worker_dep_id'] = _workerDepId;
    map['dep'] = _dep;
    map['db'] = _db;
    map['host'] = _host;
    map['port'] = _port;

    return map;
  }
}

// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

/// app : "AIS3USON web"
/// name : "test"
/// worker_dep_id: 1
/// api_key : "123"
/// otd_id : 1
/// otd : "otd test"
/// db : "kcson"
/// host : "192.168.0.102"
/// port : "48080"

// ignore_for_file:invalid_assignment
// ignore_for_file:avoid_dynamic_calls
@immutable
class WorkerKey {
  String get app => _app;

  String get name => _name;

  int get workerDepId => _workerDepId;

  String get apiKey => _apiKey;

  int get otdId => _otdId;

  String get otd => _otd;

  String get db => _db;

  String get host => _host;

  String get port => _port;

  String get httpBody => '''{"api_key": $_apiKey}''';

  @override
  int get hashCode {
    return '${_apiKey.hashCode} + ${_otd.hashCode} + ${_host.hashCode}'
        .hashCode;
  }

  String _app = '';
  String _name = '';
  int _workerDepId = 0;
  String _apiKey = '';
  int _otdId = 0;
  String _otd = '';
  String _db = '';
  String _host = '';
  String _port = '';

  WorkerKey({
    required String app,
    required String name,
    required int workerDepId,
    required String apiKey,
    required int otdId,
    required String otd,
    required String db,
    required String host,
    required String port,
  }) {
    _app = app;
    _name = name;
    _workerDepId = workerDepId;
    _apiKey = apiKey;
    _otdId = otdId;
    _otd = otd;
    _db = db;
    _host = host;
    _port = port;
  }

  // ignore: avoid_annotating_with_dynamic
  WorkerKey.fromJson(dynamic json) {
    _app = json['app'];
    _name = json['name'];
    _workerDepId = json['worker_dep_id'];
    _apiKey = json['api_key'];
    _otdId = json['otd_id'];
    _otd = json['otd'];
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
        _workerDepId == other.workerDepId &&
        _apiKey == other.apiKey &&
        _otdId == other.otdId &&
        _otd == other.otd &&
        _db == other.db &&
        _host == other.host &&
        _port == other.port;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app'] = _app;
    map['name'] = _name;
    map['worker_dep_id'] = _workerDepId;
    map['api_key'] = _apiKey;
    map['otd_id'] = _otdId;
    map['otd'] = _otd;
    map['db'] = _db;
    map['host'] = _host;
    map['port'] = _port;

    return map;
  }
}

// import 'package:flutter/material.dart';

/// app : "AIS3USON web"
/// name : "test"
/// api_key : "123"
/// otd_id : 1
/// otd : "otd test"
/// db : "kcson"
/// host : "192.168.0.102"
/// port : "48080"

class UserKey {
  String _app = "";
  String _name = "";
  String _apiKey = "";
  int _otdId = 0;
  String _otd = "";
  String _db = "";
  String _host = "";
  String _port = "";

  UserKey({
    required String app,
    required String name,
    required String apiKey,
    required int otdId,
    required String otd,
    required String db,
    required String host,
    required String port,
  }) {
    _app = app;
    _name = name;
    _apiKey = apiKey;
    _otdId = otdId;
    _otd = otd;
    _db = db;
    _host = host;
    _port = port;
  }

  UserKey.fromJson(dynamic json) {
    _app = json['app'];
    _name = json['name'];
    _apiKey = json['api_key'];
    _otdId = json['otd_id'];
    _otd = json['otd'];
    _db = json['db'];
    _host = json['host'];
    _port = json['port'];
  }

  String get app => _app;

  String get name => _name;

  String get apiKey => _apiKey;

  int get otdId => _otdId;

  String get otd => _otd;

  String get db => _db;

  String get host => _host;

  String get port => _port;

  String get httpBody => '''{"api_key": $_apiKey}''';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app'] = _app;
    map['name'] = _name;
    map['api_key'] = _apiKey;
    map['otd_id'] = _otdId;
    map['otd'] = _otd;
    map['db'] = _db;
    map['host'] = _host;
    map['port'] = _port;

    return map;
  }
}

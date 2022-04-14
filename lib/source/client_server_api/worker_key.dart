// ignore: unused_import
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_key.freezed.dart';

part 'worker_key.g.dart';

/// Immutable class to create [WorkerKey] from/to JSON strings.
///
/// Example key look like this:
/// app : "AIS3USON web"
/// api_key : "3.015679841875732e17ef73dc17-7af8-11ec-b7f8-04d9f5c97b0c"
/// name : "Test"
/// worker_dep_id: 1
/// dep_id : 1
/// dep : "Test Department"
/// servers: "https://alexqwesa.fvds.ru:48080|http://alexqwesa.fvds.ru:48081/|https://192.168.0.102:48082"
/// host : "192.168.0.102" // obsolete
/// port : "48080" // obsolete
/// db : "kcson"
/// comment : "any text"
/// certBase64 : ""
///
/// Note: https:// or http:// in servers strings is necessary!
/// {@category Client-Server API}
@freezed
class WorkerKey with _$WorkerKey {
  const factory WorkerKey({
    required String app,
    required String name,
    required String api_key,
    required int worker_dep_id,
    required String dep,
    required String db,
    required String servers,
    @Default(0) int activeServerIndex,
    @Default('') String comment,
    @Default('') String certBase64,
  }) = _WorkerKey;

  const WorkerKey._();

  factory WorkerKey.fromJson(Map<String, dynamic> json) =>
      _$$_WorkerKeyFromJson(json);

  String get activeServer {
    final server = servers.split('|')[activeServerIndex];

    return server.endsWith('/')
        ? server.substring(0, server.length - 1)
        : server;
  }

  String get activeHttp {
    return activeServer.split(':')[0];
  }

  String get activePort {
    var port = '80';
    if (activeServer.split(':').length > 2) {
      port = activeServer.split(':')[2];
      port = port.contains('/') ? port.substring(0, port.indexOf('/')) : port;
    }

    return port;
  }

  String get activeHost {
    final address = activeServer.split(':')[1].substring('//'.length);

    return address.contains('/')
        ? address.substring(0, address.indexOf('/'))
        : address;
  }

  String get activePath {
    final address = activeServer.split(':')[1].substring('//'.length);
    final path =
        address.contains('/') ? address.substring(address.indexOf('/')) : '/';

    return path.endsWith('/') ? path : '$path/';
  }

  int get workerDepId => worker_dep_id;

  String get apiKey => api_key;

  Uint8List? get certificate {
    if (certBase64.isNotEmpty) const Base64Decoder().convert(certBase64);

    return null;
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:ais3uson_app/providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_key.freezed.dart';

part 'worker_key.g.dart';

/// A class to import and store information about [Worker], can import/export as JSON strings.
///
/// api_key - should be unique for each [Worker].
///
/// TODO: implement active server switch.
///
/// Example key look like this:
/// ```
/// app : "AIS3USON web"
/// api_key : "3.01567984187"
/// name : "Test"
/// worker_dep_id: 1
/// dep_id : 1
/// dep : "Test Department"
/// servers: "https://alexqwesa.fvds.ru:48080|http://alexqwesa.fvds.ru:48081/|https://192.168.0.102:48082"
/// db : "kcson"
/// comment : "any text"
/// certBase64 : ""
/// ```
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
    final splitUrl = activeServer.split(':');
    if (splitUrl.length > 2) {
      port = splitUrl[2];
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
}

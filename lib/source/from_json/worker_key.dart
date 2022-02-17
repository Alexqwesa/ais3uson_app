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
/// host : "192.168.0.102"
/// port : "48080"
/// db : "kcson"
/// comment : "any text"
/// certBase64 : ""
///
/// {@category Import_from_json}
@freezed
class WorkerKey with _$WorkerKey {
  int get workerDepId => worker_dep_id;

  String get apiKey => api_key;

  Uint8List get certificate => const Base64Decoder().convert(certBase64!);

  const factory WorkerKey({
    required String app,
    required String name,
    required String api_key,
    required int worker_dep_id,
    required String dep,
    required String db,
    required String host,
    required String port,
    @Default('') String? comment,
    @Default('auto') String? ssl,
    @Default('') String? certBase64,
  }) = _WorkerKey;

  const WorkerKey._();

  factory WorkerKey.fromJson(Map<String, dynamic> json) =>
      _$$_WorkerKeyFromJson(json);
}

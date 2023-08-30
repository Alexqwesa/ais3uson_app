// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_client_service_request.freezed.dart';

part 'add_client_service_request.g.dart';

/// Create Json request to add a service.
///
/// {@category Client-Server API}
@freezed
@JsonSerializable()
class AddClientServiceRequest with _$AddClientServiceRequest {
  const factory AddClientServiceRequest({
    required String vdate,
    required String uuid,
    required int contracts_id,
    required int dep_has_worker_id,
    required int serv_id,
  }) = _AddClientServiceRequest;

  const AddClientServiceRequest._();

  String toJson() => jsonEncode(_$AddClientServiceRequestToJson(this));
}

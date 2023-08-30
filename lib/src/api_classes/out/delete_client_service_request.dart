// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_client_service_request.freezed.dart';

part 'delete_client_service_request.g.dart';

/// Create Json request to delete a service.
///
/// {@category Client-Server API}
@freezed
@JsonSerializable()
class DeleteClientServiceRequest with _$DeleteClientServiceRequest {
  const factory DeleteClientServiceRequest({
    required String uuid,
    required int serv_id,
    required int contracts_id,
    required int dep_has_worker_id,
  }) = _DeleteClientServiceRequest;

  const DeleteClientServiceRequest._();

  String toJson() => jsonEncode(_$DeleteClientServiceRequestToJson(this));
}

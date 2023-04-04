// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_client_service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteClientServiceRequest _$DeleteClientServiceRequestFromJson(
        Map<String, dynamic> json) =>
    DeleteClientServiceRequest(
      uuid: json['uuid'] as String,
      serv_id: json['serv_id'] as int,
      contracts_id: json['contracts_id'] as int,
      dep_has_worker_id: json['dep_has_worker_id'] as int,
    );

Map<String, dynamic> _$DeleteClientServiceRequestToJson(
        DeleteClientServiceRequest instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'serv_id': instance.serv_id,
      'contracts_id': instance.contracts_id,
      'dep_has_worker_id': instance.dep_has_worker_id,
    };

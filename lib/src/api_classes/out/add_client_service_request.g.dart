// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_client_service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddClientServiceRequest _$AddClientServiceRequestFromJson(
        Map<String, dynamic> json) =>
    AddClientServiceRequest(
      vdate: json['vdate'] as String,
      uuid: json['uuid'] as String,
      contracts_id: json['contracts_id'] as int,
      dep_has_worker_id: json['dep_has_worker_id'] as int,
      serv_id: json['serv_id'] as int,
    );

Map<String, dynamic> _$AddClientServiceRequestToJson(
        AddClientServiceRequest instance) =>
    <String, dynamic>{
      'vdate': instance.vdate,
      'uuid': instance.uuid,
      'contracts_id': instance.contracts_id,
      'dep_has_worker_id': instance.dep_has_worker_id,
      'serv_id': instance.serv_id,
    };

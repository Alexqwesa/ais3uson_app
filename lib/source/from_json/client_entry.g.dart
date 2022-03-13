// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ClientEntry _$$_ClientEntryFromJson(Map<String, dynamic> json) =>
    _$_ClientEntry(
      contract_id: json['contract_id'] as int,
      dep_id: json['dep_id'] as int,
      client_id: json['client_id'] as int,
      dhw_id: json['dhw_id'] as int,
      contract: json['contract'] as String? ?? 'ERROR',
      client: json['client'] as String? ?? 'ERROR',
      contract_duration: json['contract_duration'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      percent: (json['percent'] as num?)?.toDouble() ?? 0.0,
      max_pay: (json['max_pay'] as num?)?.toDouble() ?? double.infinity,
    );

Map<String, dynamic> _$$_ClientEntryToJson(_$_ClientEntry instance) =>
    <String, dynamic>{
      'contract_id': instance.contract_id,
      'dep_id': instance.dep_id,
      'client_id': instance.client_id,
      'dhw_id': instance.dhw_id,
      'contract': instance.contract,
      'client': instance.client,
      'contract_duration': instance.contract_duration,
      'comment': instance.comment,
      'percent': instance.percent,
      'max_pay': instance.max_pay,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ClientPlan _$$_ClientPlanFromJson(Map<String, dynamic> json) =>
    _$_ClientPlan(
      contract_id: json['contract_id'] as int,
      serv_id: json['serv_id'] as int,
      planned: json['planned'] as int,
      filled: json['filled'] as int,
    );

Map<String, dynamic> _$$_ClientPlanToJson(_$_ClientPlan instance) =>
    <String, dynamic>{
      'contract_id': instance.contract_id,
      'serv_id': instance.serv_id,
      'planned': instance.planned,
      'filled': instance.filled,
    };

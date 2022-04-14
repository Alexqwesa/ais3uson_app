// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WorkerKey _$$_WorkerKeyFromJson(Map<String, dynamic> json) => _$_WorkerKey(
      app: json['app'] as String,
      name: json['name'] as String,
      api_key: json['api_key'] as String,
      worker_dep_id: json['worker_dep_id'] as int,
      dep: json['dep'] as String,
      db: json['db'] as String,
      servers: json['servers'] as String,
      activeServerIndex: json['activeServerIndex'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      certBase64: json['certBase64'] as String? ?? '',
    );

Map<String, dynamic> _$$_WorkerKeyToJson(_$_WorkerKey instance) =>
    <String, dynamic>{
      'app': instance.app,
      'name': instance.name,
      'api_key': instance.api_key,
      'worker_dep_id': instance.worker_dep_id,
      'dep': instance.dep,
      'db': instance.db,
      'servers': instance.servers,
      'activeServerIndex': instance.activeServerIndex,
      'comment': instance.comment,
      'certBase64': instance.certBase64,
    };

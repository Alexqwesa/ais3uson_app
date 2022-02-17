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
      host: json['host'] as String,
      port: json['port'] as String,
      comment: json['comment'] as String? ?? '',
      ssl: json['ssl'] as String? ?? 'auto',
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
      'host': instance.host,
      'port': instance.port,
      'comment': instance.comment,
      'ssl': instance.ssl,
      'certBase64': instance.certBase64,
    };

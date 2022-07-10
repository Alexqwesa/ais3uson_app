// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ServiceEntry _$$_ServiceEntryFromJson(Map<String, dynamic> json) =>
    _$_ServiceEntry(
      id: json['id'] as int,
      serv_text: json['serv_text'] as String,
      image: json['image'] as String? ?? 'not-found.png',
      tnum: json['tnum'] as String? ?? '___',
      total: json['total'] as int? ?? 0,
      short_text: json['short_text'] as String? ?? '',
      serv_id_list: json['serv_id_list'] as String? ?? '',
      sub_serv: json['sub_serv'] as int? ?? 1,
      comment: json['comment'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_ServiceEntryToJson(_$_ServiceEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serv_text': instance.serv_text,
      'image': instance.image,
      'tnum': instance.tnum,
      'total': instance.total,
      'short_text': instance.short_text,
      'serv_id_list': instance.serv_id_list,
      'sub_serv': instance.sub_serv,
      'comment': instance.comment,
      'price': instance.price,
    };

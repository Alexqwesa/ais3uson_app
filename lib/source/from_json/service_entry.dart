// ignore_for_file: flutter_style_todos

import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:flutter/cupertino.dart';

/// id : 558
/// tnum : ""
/// serv_text : ":"
/// total : 1
/// image : "None"
/// serv_id_list : "558807"

// ignore_for_file:invalid_assignment, avoid_annotating_with_dynamic
// ignore_for_file:avoid_dynamic_calls

@immutable
class ServiceEntry {
  late final int _id;
  late final String _tnum;
  late final String _servText;
  late final int _total;
  late final String _image;
  late final String _servIdList;
  late final int _subServ;
  late final String _shortText;

  int get id => _id;

  String get tNum => _tnum;

  int get total => _total;

  String get image {
    if (total > 0) {
      return _image.isNotEmpty ? _image : 'total.png';
    }

    return _image.isNotEmpty ? _image : 'not-found.png';
  }

  String get servIdList => _servIdList;

  int get subServ => _subServ;

  String get servText => _servText;

  String get servTextAdd {
    if (_shortText.isEmpty || _servText.startsWith(_shortText)) {
      final res = _servText.substring(shortText.length, _servText.length);

      return res.isNotEmpty ? '...$res' : '';
    }

    // TODO: is it really better? maybe just return _servText ?
    return cutFromStart(_servText, shortText) ;
  }

  String get shortText {
    if (_shortText.isNotEmpty) return _shortText;
    final shText = _servText.substring(
      0,
      100 > _servText.length ? _servText.length : 100,
    );

    return shText;
  }

  ServiceEntry({
    int id = 0,
    String? tnum,
    String? servText,
    int? total,
    String? image,
    String? servIdList,
    int? subServ,
    String? shortText,
  }) {
    _id = id;
    _tnum = tnum ?? '___';
    _servText = servText ?? '';
    _total = total ?? 0;
    _image = image ?? '';
    _servIdList = servIdList ?? '';
    _subServ = subServ ?? 0;
    _shortText = shortText ?? '';
  }

  ServiceEntry.fromJson(dynamic json) {
    _id = json['id'] ?? 0;
    _servText = json['serv_text'] ?? '';
    _total = json['total'] ?? 0;
    _servIdList = json['serv_id_list'] ?? '';
    _tnum = json['tnum'] ?? 'ERROR';
    _image = json['image'] ?? '';
    _subServ = json['sub_serv'] ?? '';
    _shortText = json['short_text'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['tnum'] = _tnum;
    map['serv_text'] = _servText;
    map['total'] = _total;
    map['image'] = _image;
    map['serv_id_list'] = _servIdList;
    map['sub_serv'] = _subServ;
    map['short_text'] = _shortText;

    return map;
  }
}

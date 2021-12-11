/// id : 558
/// tnum : ""
/// serv_text : ":"
/// total : 1
/// image : "None"
/// serv_id_list : "558807"

// ignore_for_file:invalid_assignment, avoid_annotating_with_dynamic
// ignore_for_file:avoid_dynamic_calls

class ServiceEntry {
  int get id => _id;

  String get tarifNum => _tnum;

  String get servText => _servText;

  int get total => _total;

  String get image => _image;

  String get servIdList => _servIdList;

  int get subServ => _subServ;

  String get shortText => _shortText;

  int _id = 0;
  String _tnum = '';
  String _servText = '';
  int _total = 0;
  String _image = '';
  String _servIdList = '';
  int _subServ = 0;
  String _shortText = '';

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
    _tnum = tnum ?? _tnum;
    _servText = servText ?? _servText;
    _total = total ?? _total;
    _image = image ?? _image;
    _servIdList = servIdList ?? _servIdList;
    _subServ = subServ ?? _subServ;
    _shortText = shortText ?? _shortText;
  }

  ServiceEntry.fromJson(dynamic json) {
    _id = json['id'];
    _servText = json['serv_text'];
    _total = json['total'];
    _servIdList = json['serv_id_list'];
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

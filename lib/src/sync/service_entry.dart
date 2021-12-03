/// id : 558
/// tnum : ""
/// serv_text : ":"
/// total : 1
/// image : "None"
/// serv_id_list : "558807"

class ServiceEntry {
  ServiceEntry({
      int? id, 
      String? tnum, 
      String? servText, 
      int? total, 
      String? image, 
      String? servIdList,}){
    _id = id;
    _tnum = tnum;
    _servText = servText;
    _total = total;
    _image = image;
    _servIdList = servIdList;
}

  ServiceEntry.fromJson(dynamic json) {
    _id = json['id'];
    _tnum = json['tnum'];
    _servText = json['serv_text'];
    _total = json['total'];
    _image = json['image'];
    _servIdList = json['serv_id_list'];
  }
  int? _id;
  String? _tnum;
  String? _servText;
  int? _total;
  String? _image;
  String? _servIdList;

  int? get id => _id;
  String? get tnum => _tnum;
  String? get servText => _servText;
  int? get total => _total;
  String? get image => _image;
  String? get servIdList => _servIdList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['tnum'] = _tnum;
    map['serv_text'] = _servText;
    map['total'] = _total;
    map['image'] = _image;
    map['serv_id_list'] = _servIdList;
    return map;
  }

}
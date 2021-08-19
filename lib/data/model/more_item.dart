
import '../../utils/log_utils.dart';

class MoreItem {
  String _name;
  String _id;
  String _image;
  String _type;

  MoreItem({String name, String id, String type, String image}) {
    _name = name;
    _id = id;
    _image = image;
    _type = type;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get id => _id;
  set id(String id) => _id = id;
  String get type => _type;
  set type(String type) => _type = type;
  String get image => _image;
  set image(String image) => _image = image;

  MoreItem.fromJson(Map<String, dynamic> json) {
    try{
      _name = json['name'];
      _id = json['id'];
      _image = json['image'];
      _type = json['type'];
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = _name;
    data['id'] = _id;
    data['image'] = _image;
    data['type'] = _type;
    return data;
  }
}

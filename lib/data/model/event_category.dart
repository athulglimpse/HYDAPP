import '../../utils/log_utils.dart';

class EventCategory {
  int _id;
  String _name;

  EventCategory({int id, String name}) {
    _id = id;
    _name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  EventCategory.fromJson(Map<String, dynamic> json) {
    try {
      _id = json['id'];
      _name = json['name'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    return data;
  }
}

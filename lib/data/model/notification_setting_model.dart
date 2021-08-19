import '../../utils/log_utils.dart';

class NotificationSettingModel {
  int _id;
  String _name;
  String _type;
  int _status;
  bool _hasChange;

  NotificationSettingModel({int id, String name, String type, int status}) {
    _id = id;
    _name = name;
    _type = type;
    _status = status;
    _hasChange = false;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get type => _type;
  set type(String type) => _type = type;
  int get status => _status;
  set status(int status) => _status = status;
  bool get hasChange => _hasChange;
  set hasChange(bool hasChange) => _hasChange = hasChange;


  bool get isOn => (_status ?? 0) == 1;

  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    try {
      _id = json['id'];
      _name = json['name'];
      _type = json['type'];
      _status = json['status'];
      _hasChange = false;
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['type'] = _type;
    data['status'] = _status;
    return data;
  }
}

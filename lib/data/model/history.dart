import '../../utils/log_utils.dart';

class HistoryInfo {
  int _id;
  String _title;
  String _type;
  String _image;
  String _url;
  String _date;

  HistoryInfo({
    int id,
    String title,
    String type,
    String image,
    String url,
    String date,
  }) {
    _id = id;
    _title = title;
    _type = type;
    _image = image;
    _url = url;
    _date = date;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get title => _title;
  set title(String title) => _title = title;
  String get type => _type;
  set type(String type) => _type = type;
  String get image => _image;
  set image(String image) => _image = image;
  String get url => _url;
  set url(String url) => _url = url;
  String get date => _date;
  set date(String date) => _date = date;

  HistoryInfo.fromJson(Map<String, dynamic> json) {
    try{
      _id = json['id'];
      _title = json['title'];
      _type = json['type'];
      _image = json['image'];
      _url = json['url'];
      _date = json['date'];
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['type'] = _type;
    data['image'] = _image;
    data['url'] = _url;
    data['date'] = _date;
    return data;
  }
}

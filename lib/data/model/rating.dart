import '../../utils/log_utils.dart';

class RatingInfo {
  int _id;
  String _title;
  String _image;
  String _url;
  String _rate;
  String _lat;
  String _long;

  RatingInfo({
    int id,
    String title,
    String image,
    String url,
    String lat,
    String long,
    String rate,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _lat = lat;
    _long = long;
    _url = url;
    _rate = rate;
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  String get image => _image;

  set image(String image) => _image = image;

  String get url => _url;

  set url(String url) => _url = url;

  String get rate => _rate;

  set rate(String rate) => _rate = rate;

  String get lat => _lat;

  set lat(String lat) => _lat = lat;

  String get long => _long;

  set long(String long) => _long = long;

  RatingInfo.fromJson(Map<String, dynamic> json) {
    try {
      _id = json['id'];
      _title = json['title'];
      _image = json['image'];
      _url = json['url'];
      _rate = json['rate'];
      _lat = json['lat'];
      _long = json['long'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = _id;
    data['title'] = _title;
    data['image'] = _image;
    data['url'] = _url;
    data['rate'] = _rate;
    data['lat'] = _lat;
    data['long'] = _long;
    return data;
  }
}

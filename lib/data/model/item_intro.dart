import '../../utils/log_utils.dart';

class ItemIntro {
  String _image;
  String _title;
  String _content;

  ItemIntro({String image, String title, String content}) {
    _image = image;
    _title = title;
    _content = content;
  }

  String get image => _image;
  set image(String image) => _image = image;
  String get title => _title;
  set title(String title) => _title = title;
  String get content => _content;
  set content(String content) => _content = content;

  ItemIntro.fromJson(Map<String, dynamic> json) {
    try {
      _image = json['image'];
      _title = json['title'];
      _content = json['content'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = _image;
    data['title'] = _title;
    data['content'] = _content;
    return data;
  }
}

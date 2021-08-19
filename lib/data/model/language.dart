import '../../utils/log_utils.dart';

class Language {
  String _name;
  String _code;
  String _countryCode;
  String _image;

  Language({String name, String code, String image}) {
    _name = name;
    _code = code;
    _image = image;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get countryCode => _countryCode;
  set countryCode(String countryCode) => _countryCode = countryCode;
  String get code => _code;
  set code(String code) => _code = code;
  String get image => _image;
  set image(String image) => _image = image;

  Language.fromJson(Map<String, dynamic> json) {
    try {
      _name = json['name'];
      _code = json['code'];
      _countryCode = json['country_code'];
      _image = json['image'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = _name;
    data['code'] = _code;
    data['countryCode'] = _countryCode;
    data['image'] = _image;
    return data;
  }
}

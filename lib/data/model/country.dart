import '../../utils/log_utils.dart';

class Country {
  String _name;
  String _code;
  String _dialCode;

  Country({
    String name,
    String code,
    String dialCode,
  }) {
    _name = name;
    _code = code;
    _dialCode = dialCode;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get code => _code;
  set code(String code) => _code = code;
  String get dialCode => _dialCode;
  set dialCode(String dialCode) => _dialCode = dialCode;

  Country.fromJson(Map<String, dynamic> json) {
    try {
      _name = json['name'];
      _code = json['code'];
      _dialCode = json['dial_code'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = _name;
    data['code'] = _code;
    data['dial_code'] = _dialCode;
    return data;
  }
}

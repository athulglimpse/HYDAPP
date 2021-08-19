import '../../utils/log_utils.dart';

class RegisterInfo {
  String _tokenCode;
  String _accessToken;

  RegisterInfo({String tokenCode, String accessToken}) {
    _tokenCode = tokenCode;
    _accessToken = accessToken;
  }

  String get tokenCode => _tokenCode;
  set tokenCode(String tokenCode) => _tokenCode = tokenCode;

  String get accessToken => _accessToken;
  set accessToken(String accessToken) => _accessToken = accessToken;

  RegisterInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    try {
      _tokenCode = json['token_code'];
      _accessToken = json['access_token'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token_code'] = _tokenCode;
    data['access_token'] = _accessToken;
    return data;
  }
}

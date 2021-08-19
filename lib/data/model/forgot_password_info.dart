class ForgotPasswordInfo {
  String _tokenCode;

  ForgotPasswordInfo({String tokenCode}) {
    _tokenCode = tokenCode;
  }
  String get tokenCode => _tokenCode;
  set tokenCode(String tokenCode) => _tokenCode = tokenCode;

  ForgotPasswordInfo.fromJson(Map<String, dynamic> json) {
    _tokenCode = json['token_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token_code'] = _tokenCode;
    return data;
  }
}

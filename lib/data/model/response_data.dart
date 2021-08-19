class ResponseData {
  dynamic _data;
  String _message;
  String _responseCode;
  int _statusCode;

  ResponseData({String data, int statusCode}) {
    _data = data;
    _statusCode = statusCode;
  }

  String get responseCode => _responseCode;
  set responseCode(String responseCode) => _responseCode = responseCode;
  String get message => _message;
  set message(String message) => _message = message;
  dynamic get data => _data;
  set data(dynamic data) => _data = data;
  int get statusCode => _statusCode;
  set statusCode(int statusCode) => _statusCode = statusCode;

  ResponseData.fromJson(Map<String, dynamic> json) {
    _data = json['data'];
    _message = json['message'];
    _statusCode = json['status'];
    _responseCode = json['response_code'];
  }
}

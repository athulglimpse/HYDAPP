class UnityResponseData {
  String data;
  String message;
  String responseCode;

  UnityResponseData.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    responseCode = json['responseCode'];
  }
}

class LocationResponse {
  String id;
  String latti;
  String longti;

  LocationResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latti = json['latti'];
    longti = json['longti'];
  }
}

class DirectionRequest {
  String id;
  String intro;
  String nextIntro;
  String latti;
  String longti;
  String direction;
  String eta;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['intro'] = intro;
    data['nextIntro'] = nextIntro;
    data['latti'] = latti;
    data['longti'] = longti;
    data['direction'] = direction;
    data['eta'] = eta;

    return data;
  }
}

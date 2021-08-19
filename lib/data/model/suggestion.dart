import '../../utils/log_utils.dart';

import 'image_info.dart';

class AmenityInfo {
  int id;
  String title;
  ImageInfoData image;
  String url;
  String suitableAge;

  AmenityInfo({
    int id,
    String title,
    ImageInfoData image,
    String url,
    String suitableAge,
  }) {
    id = id;
    title = title;
    image = image;
    url = url;
    suitableAge = suitableAge;
  }

  AmenityInfo.fromJson(Map<String, dynamic> json) {
    doParseFromJson(json);
  }

  void doParseFromJson(Map<String, dynamic> json) {
    try{
      id = json['id'];
      title = json['title'];
      if (json['image'] != null) {
        image = ImageInfoData.fromJson(json['image']);
      }
      url = json['url'];
      suitableAge = json['suitable_age'];
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (image != null) {
      data['image'] = image.toJson();
    }
    data['url'] = url;
    data['suitable_age'] = suitableAge;
    return data;
  }
}

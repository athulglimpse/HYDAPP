import '../../utils/log_utils.dart';

class ImageInfoData {
  int id;
  String url;
  String name;
  String title;

  ImageInfoData.fromJson(Map<String, dynamic> json) {
    try{
      if (json['id'] is int) {
        id = json['id'];
      }
      url = json['url'];
      if (json['image'] != null && json['image'] is String) {
        url = json['image'];
      }
      name = json['name'];
      title = json['title'];
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['name'] = name;
    data['title'] = title;
    return data;
  }
}

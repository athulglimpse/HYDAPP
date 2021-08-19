import 'image_info.dart';
import 'places_model.dart';
import 'suitable_model.dart';

class ActivityModel {
  int id;
  String title;
  String note;
  String phoneNumber;
  List<SuitableModel> suitable;
  String description;
  ImageInfoData image;
  String shareUrl;
  List<PlaceModel> detail;

  ActivityModel({this.id, this.title, this.note, this.image, this.shareUrl});

  SuitableModel get pickOneSuitable {
    return (suitable?.length ?? 0) > 0 ? suitable[0] : null;
  }


  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    phoneNumber = json['phone_number'];
    note = json['note'];
    image = (json['image'] != null && json['image'] is Map)
        ? ImageInfoData.fromJson(json['image'])
        : null;
    shareUrl = json['share_url'];
    if (json['detail'] != null && json['detail'] is List) {
      detail = <PlaceModel>[];
      json['detail'].forEach((v) {
        detail.add(PlaceModel.fromJson(v));
      });
    }
    if (json['suitable'] != null) {
      suitable = <SuitableModel>[];
      json['suitable'].forEach((v) {
        suitable.add(SuitableModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['title'] = title;
    data['phone_number'] = phoneNumber;
    data['note'] = note;
    if (image != null) {
      data['image'] = image.toJson();
    }
    if (detail != null) {
      data['detail'] = detail.map((v) => v.toJson()).toList();
    }
    data['share_url'] = shareUrl;
    if (suitable != null) {
      data['suitable'] = suitable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import '../../utils/log_utils.dart';

import 'amenity_model.dart';

import 'category_model.dart';
import 'image_info.dart';
import 'location_model.dart';
import 'open_time_model.dart';
import 'save_item_model.dart';
import 'suitable_model.dart';

class EventInfo {
  int id;
  String name;
  String title;
  String shortDescription;
  String introDescription;
  List<LocationModel> location;
  ImageInfoData image;
  ImageInfoData thumb;
  bool isFavorite;
  String rate;
  List<OpenTimeModel> eventTime;
  CategoryModel category;
  List<SuitableModel> suitable;
  List<ImageInfoData> gallery;
  String note;
  String shareUrl;
  String type;
  double distance;

  EventInfo(
      {this.id,
      this.name,
      this.title,
      this.shortDescription,
      this.introDescription,
      this.location,
      this.image,
      this.thumb,
      this.isFavorite,
      this.rate,
      this.eventTime,
      this.category,
      this.suitable,
      this.gallery,
      this.note,
      this.shareUrl,
      this.type});

  EventInfo.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      distance = json['distance'];
      title = json['title'];
      shortDescription = json['short_description'];
      introDescription = json['intro_description'];
      if (json['location'] != null) {
        location = <LocationModel>[];
        json['location'].forEach((v) {
          location.add(LocationModel.fromJson(v));
        });
      }
      image =
          json['image'] != null ? ImageInfoData.fromJson(json['image']) : null;
      thumb =
          json['thumb'] != null ? ImageInfoData.fromJson(json['thumb']) : null;
      isFavorite = json['is_favorite'];
      rate = json['rate'];
      if (json['event_multi_dates'] != null) {
        eventTime = <OpenTimeModel>[];
        json['event_multi_dates'].forEach((v) {
          eventTime.add(OpenTimeModel.fromJson(v));
        });
      }
      category = (json['category'] != null && json['category'] is Map)
          ? CategoryModel.fromJson(json['category'])
          : null;
      if (json['suitable'] != null) {
        suitable = <SuitableModel>[];
        json['suitable'].forEach((v) {
          suitable.add(SuitableModel.fromJson(v));
        });
      }
      if (json['gallery'] != null) {
        gallery = <ImageInfoData>[];
        json['gallery'].forEach((v) {
          gallery.add(ImageInfoData.fromJson(v));
        });
      }
      note = json['note'];
      shareUrl = json['share_url'];
      type = json['type'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['short_description'] = shortDescription;
    data['intro_description'] = introDescription;
    if (location != null) {
      data['location'] = location.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image.toJson();
    }
    if (thumb != null) {
      data['thumb'] = thumb.toJson();
    }
    data['is_favorite'] = isFavorite;
    data['rate'] = rate;
    if (eventTime != null) {
      data['event_multi_dates'] = eventTime.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category.toJson();
    }
    if (suitable != null) {
      data['suitable'] = suitable.map((v) => v.toJson()).toList();
    }
    if (gallery != null) {
      data['gallery'] = gallery.map((v) => v.toJson()).toList();
    }
    data['note'] = note;
    data['share_url'] = shareUrl;
    data['type'] = type;
    return data;
  }

  //
  // List<LocationModel> location;
  // @JsonKey(name: 'image')
  // ImageInfoData image;
  // @JsonKey(name: 'thumb')
  // ImageInfoData thumb;
  // @JsonKey(name: 'is_favorite')
  // bool isFavorite;
  // @JsonKey(name: 'rate')
  // String rate;
  // @JsonKey(name: 'event_time')
  // List<OpenTimeModel> eventTime;
  // @JsonKey(name: 'category')
  // CategoryModel category;
  // @JsonKey(name: 'share_url')
  // String shareUrl;
  // @JsonKey(name: 'note')
  // String note;
  // @JsonKey(name: 'suitable')
  // List<SuitableModel> suitable;
  // @JsonKey(name: 'gallery')
  // List<ImageInfoData> gallery;
  //
  // EventInfo({
  //   this.id,
  //   this.title,
  //   this.location,
  //   this.image,
  //   this.thumb,
  //   this.isFavorite,
  //   this.rate,
  //   this.eventTime,
  //   this.category,
  //   this.shareUrl,
  //   this.suitable,
  //   this.gallery,
  //   this.note,
  // });
  //
  factory EventInfo.convertSearchModel(AmenityModel itemModel) {
    final model = itemModel.parent;
    return EventInfo(
      id: model.id,
      title: model.title,
      location: model.location,
      image: model.image,
      thumb: model.thumb,
      isFavorite: model.isFavorite,
      rate: model.rate,
      eventTime: model.eventTime,
      category: model.category,
      shareUrl: model.shareUrl,
      suitable: model.suitable,
      gallery: model.gallery,
      note: model.note,
    );
  }

  factory EventInfo.convertFromSaveItem(SaveItemModel itemModel) {
    return EventInfo(
      id: itemModel.id,
      title: itemModel.title,
      location: itemModel.location,
      image: itemModel.image,
      thumb: itemModel.thumb,
      isFavorite: itemModel.isFavorite,
      rate: itemModel.rate,
      eventTime: itemModel.eventTime,
      category: itemModel.category,
      shareUrl: itemModel.shareUrl,
      suitable: itemModel.suitable,
      gallery: itemModel.gallery,
      note: itemModel.note,
    );
  }

  LocationModel get pickOneLocation {
    return (location?.length ?? 0) > 0 ? location[0] : null;
  }

  OpenTimeModel get pickOneEventTime {
    return (eventTime?.length ?? 0) > 0 ? eventTime[0] : null;
  }

  // factory EventInfo.fromJson(Map<String, dynamic> json) =>
  //     _$EventInfoFromJson(json);
  // Map<String, dynamic> toJson() => _$EventInfoToJson(this);
}

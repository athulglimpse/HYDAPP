import 'package:marvista/utils/log_utils.dart';

import 'area_item.dart';
import 'category_model.dart';
import 'image_info.dart';
import 'location_model.dart';
import 'open_time_model.dart';
import 'suitable_model.dart';

class SearchAmenitiesModel {
  int id;
  String title;
  String shortDescription;
  String introDescription;
  List<LocationModel> location;
  ImageInfoData image;
  ImageInfoData thumb;
  bool isFavorite;
  int totalReview;
  int priority;
  String rate;
  CategoryModel category;
  AreaItem experience;
  String shareUrl;
  List<ImageInfoData> gallery;
  String note;
  String phoneNumber;
  List<SuitableModel> suitable;
  List<OpenTimeModel> openTime;
  String type;
  List<OpenTimeModel> eventTime;

  SearchAmenitiesModel({
    this.id,
    this.title,
    this.shortDescription,
    this.introDescription,
    this.location,
    this.image,
    this.thumb,
    this.isFavorite,
    this.totalReview,
    this.rate,
    this.category,
    this.experience,
    this.shareUrl,
    this.gallery,
    this.note,
    this.phoneNumber,
    this.suitable,
    this.openTime,
    this.type,
  });

  List<ImageInfoData> listImage() {
    if (gallery?.isNotEmpty ?? false) {
      if (image != null) {
        return [image, ...gallery];
      }
      return gallery;
    }
    if (image != null) {
      return [image];
    }
    return [];
  }

  String pickOpenTimeByDay(int index) {
    if (openTime != null && openTime.isNotEmpty) {
      final len = openTime?.length ?? 0;
      return len > index
          ? openTime[0].openTime
          : (len > 0 ? openTime[0].openTime : '');
    } else {
      final len = eventTime?.length ?? 0;
      return len > index
          ? eventTime[0].openTime
          : (len > 0 ? eventTime[0].openTime : '');
    }
  }

  String pickCloseTimeByDay(int index) {
    if (openTime != null && openTime.isNotEmpty) {
      final len = openTime?.length ?? 0;
      return len > index
          ? openTime[0].closeTime
          : (len > 0 ? openTime[0].closeTime : '');
    } else {
      final len = eventTime?.length ?? 0;
      return len > index
          ? eventTime[0].closeTime
          : (len > 0 ? eventTime[0].closeTime : '');
    }
    // final len = openTime?.length ?? 0;
    // return len > index
    //     ? openTime[0].closeTime
    //     : (len > 0 ? openTime[0].closeTime : '');
  }

  SuitableModel get pickOneSuitable {
    return (suitable?.length ?? 0) > 0 ? suitable[0] : null;
  }

  SearchAmenitiesModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      if (json['priority'] is int) {
        priority = json['priority'];
      }
      title = json['title'];
      shortDescription = json['short_description'];
      introDescription = json['intro_description'];
      if (json['location'] != null && json['location'] is List) {
        location = <LocationModel>[];
        json['location'].forEach((v) {
          location.add(LocationModel.fromJson(v));
        });
      }
      image = (json['image'] != null && json['image'] is Map)
          ? ImageInfoData.fromJson(json['image'])
          : null;
      thumb = (json['thumb'] != null && json['thumb'] is Map)
          ? ImageInfoData.fromJson(json['thumb'])
          : null;
      isFavorite = json['is_favorite'];
      totalReview = json['total_review'];
      rate = json['rate '];
      category = (json['category'] != null && json['category'] is Map)
          ? CategoryModel.fromJson(json['category'])
          : null;
      experience = (json['experience'] != null && json['experience'] is Map)
          ? AreaItem.fromJson(json['experience'])
          : null;
      shareUrl = json['share_url'];
      if (json['gallery'] != null && json['gallery'] is List) {
        gallery = <ImageInfoData>[];
        json['gallery'].forEach((v) {
          gallery.add(ImageInfoData.fromJson(v));
        });
      }
      note = json['note'];
      phoneNumber = json['phone_number'];
      if (json['suitable'] != null && json['suitable'] is List) {
        suitable = <SuitableModel>[];
        json['suitable'].forEach((v) {
          suitable.add(SuitableModel.fromJson(v));
        });
      }
      if (json['open_time'] != null && json['open_time'] is List) {
        openTime = <OpenTimeModel>[];
        json['open_time'].forEach((v) {
          openTime.add(OpenTimeModel.fromJson(v));
        });
      }
      if (json['event_time'] != null && json['event_time'] is List) {
        eventTime = <OpenTimeModel>[];
        json['event_time'].forEach((v) {
          eventTime.add(OpenTimeModel.fromJson(v));
        });
      }
      type = json['type'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['priority'] = priority;
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
    data['total_review'] = totalReview;
    data['rate '] = rate;
    if (category != null) {
      data['category'] = category.toJson();
    }
    if (experience != null) {
      data['experience'] = experience.toJson();
    }
    data['share_url'] = shareUrl;
    if (gallery != null) {
      data['gallery'] = gallery.map((v) => v.toJson()).toList();
    }
    data['note'] = note;
    data['phone_number'] = phoneNumber;
    if (suitable != null) {
      data['suitable'] = suitable.map((v) => v.toJson()).toList();
    }
    if (openTime != null) {
      data['open_time'] = openTime.map((v) => v.toJson()).toList();
    }
    if (eventTime != null) {
      data['event_time'] = eventTime.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    return data;
  }
}

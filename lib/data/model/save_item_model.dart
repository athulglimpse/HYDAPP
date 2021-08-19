import '../../utils/log_utils.dart';

import 'asset_detail.dart';
import 'category_model.dart';
import 'experience_model.dart';
import 'image_info.dart';
import 'location_model.dart';
import 'open_time_model.dart';
import 'post_detail.dart';
import 'suitable_model.dart';

class SaveItemModel {
  String entityType;
  int id;
  String title;
  String shortDescription;
  String introDescription;
  List<LocationModel> location;
  ImageInfoData image;
  List<ImageInfoData> images;
  ImageInfoData thumb;
  bool isFavorite;
  int totalReview;
  String rate;
  CategoryModel category;
  ExperienceModel experience;
  String shareUrl;
  List<ImageInfoData> gallery;
  String note;
  String phoneNumber;
  List<SuitableModel> suitable;
  List<OpenTimeModel> openTime;
  String type;
  String caption;
  String tagLocationId;
  Author author;
  String name;
  List<OpenTimeModel> eventTime;
  AssetDetail place;

  SaveItemModel(
      {this.entityType,
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
      this.caption,
      this.tagLocationId,
      this.author,
      this.name,
      this.eventTime,
      this.place});

  SaveItemModel.fromJson(Map<String, dynamic> json) {
    try {
      entityType = json['entity_type'];
      id = json['id'];
      if (json['title'] != null) {
        title = json['title'];
      } else {
        title = json['caption'];
      }
      shortDescription = json['short_description'];
      introDescription = json['intro_description'];
      type = json['type'];
      if (json['location'] != null) {
        location = <LocationModel>[];
        json['location'].forEach((v) {
          location.add(LocationModel.fromJson(v));
        });
      }
      if (json['image'] != null && json['image'] is List) {
        images = <ImageInfoData>[];
        json['image'].forEach((v) {
          images.add(ImageInfoData.fromJson(v));
        });
      } else {
        image = json['image'] != null
            ? ImageInfoData.fromJson(json['image'])
            : null;
      }
      if (json['thumb'] is Map) {
        thumb = json['thumb'] != null
            ? ImageInfoData.fromJson(json['thumb'])
            : null;
      }
      isFavorite = json['is_favorite'];
      rate = json['rate'];
      if (json['event_time'] != null) {
        eventTime = <OpenTimeModel>[];
        json['event_time'].forEach((v) {
          eventTime.add(OpenTimeModel.fromJson(v));
        });
      }
      if (json['category'] is Map) {
        category = json['category'] != null
            ? CategoryModel.fromJson(json['category'])
            : null;
      }
      experience = json['experience'] != null
          ? ExperienceModel.fromJson(json['experience'])
          : null;
      if (json['gallery'] != null) {
        gallery = <ImageInfoData>[];
        json['gallery'].forEach((v) {
          gallery.add(ImageInfoData.fromJson(v));
        });
      }
      if (json['suitable'] != null) {
        suitable = <SuitableModel>[];
        json['suitable'].forEach((v) {
          suitable.add(SuitableModel.fromJson(v));
        });
      }
      note = json['note'];
      shareUrl = json['share_url'];
      caption = json['caption'];
      tagLocationId = json['tag_location_id'];
      author = json['author'] != null ? Author.fromJson(json['author']) : null;
      if (json['place'] != null) {
        place = AssetDetail.fromJson(json['place']);
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  LocationModel get pickOneLocation {
    return (location?.length ?? 0) > 0 ? location[0] : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['entity_type'] = entityType;
    data['id'] = id;
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
      data['event_time'] = eventTime.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['image'] = images.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category.toJson();
    }
    if (experience != null) {
      data['experience'] = experience.toJson();
    }
    if (gallery != null) {
      data['gallery'] = gallery.map((v) => v.toJson()).toList();
    }
    if (suitable != null) {
      data['suitable'] = suitable.map((v) => v.toJson()).toList();
    }
    data['note'] = note;
    data['share_url'] = shareUrl;
    data['type'] = type;
    data['caption'] = caption;
    data['tag_location_id'] = tagLocationId;
    if (author != null) {
      data['author'] = author.toJson();
    }
    if (place != null) {
      data['place'] = place.toJson();
    }
    return data;
  }
}

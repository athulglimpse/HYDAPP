import '../../utils/log_utils.dart';
import 'amenity_model.dart';
import 'category_model.dart';
import 'distance_matrix_model.dart';
import 'image_info.dart';
import 'location_model.dart';
import 'open_time_model.dart';
import 'save_item_model.dart';
import 'suitable_model.dart';

class PlaceModel {
  dynamic id;
  String title;
  List<LocationModel> location;
  ImageInfoData image;
  ImageInfoData thumb;
  dynamic totalReview;
  String rate;
  bool isFavorite;
  String description;
  CategoryModel category;
  String shareUrl;
  List<ImageInfoData> gallery;
  String note;
  List<OpenTimeModel> openTime;
  MyElementsDisMatrix elementsDisMatrix;
  List<SuitableModel> suitable;
  String eta;
  double distance;
  String etaCar;

  PlaceModel({
    this.id,
    this.title,
    this.location,
    this.image,
    this.thumb,
    this.elementsDisMatrix,
    this.totalReview,
    this.rate,
    this.category,
    this.shareUrl,
    this.suitable,
    this.gallery,
    this.note,
    this.openTime,
    this.isFavorite,
  });

  PlaceModel.fromJson(Map<String, dynamic> json) {
    parseJson(json);
  }

  LocationModel get pickOneLocation {
    return (location?.length ?? 0) > 0 ? location[0] : null;
  }

  SuitableModel get pickOneSuitable {
    return (suitable?.length ?? 0) > 0 ? suitable[0] : null;
  }

  String pickOpenTimeByDay(int index) {
    final len = openTime?.length ?? 0;
    return len > index
        ? openTime[0].openTime
        : (len > 0 ? openTime[0].openTime : '');
  }

  String pickCloseTimeByDay(int index) {
    final len = openTime?.length ?? 0;
    return len > index
        ? openTime[0].closeTime
        : (len > 0 ? openTime[0].closeTime : '');
  }

  void parseJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      title = json['title'];
      eta = json['eta'];
      etaCar = json['etaCar'];
      isFavorite = json['is_favorite'];
      description = json['intro_description'];
      if (json['location'] != null) {
        location = <LocationModel>[];
        json['location'].forEach((v) {
          location.add(LocationModel.fromJson(v));
        });
      }
      if (json['image'] is Map) {
        image = ImageInfoData.fromJson(json['image']);
      }
      if (json['thumb'] is Map) {
        thumb = ImageInfoData.fromJson(json['thumb']);
      }
      totalReview = json['total_review'];
      totalReview ??= json['review'];
      rate = json['rate'];
      category = json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null;
      shareUrl = json['share_url'];
      if (json['gallery'] != null && json['id'] != 20) {
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
      if (json['open_time'] != null && json['open_time'].runtimeType is List) {
        openTime = <OpenTimeModel>[];
        json['open_time'].forEach((v) {
          openTime.add(OpenTimeModel.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['is_favorite'] = isFavorite;
    if (location != null) {
      data['location'] = location.map((v) => v.toJson()).toList();
    }
    data['image'] = image?.toJson();
    data['thumb'] = thumb?.toJson();
    data['intro_description'] = description;
    data['total_review'] = totalReview;
    data['rate'] = rate;
    data['eta'] = eta;
    data['etaCar'] = etaCar;
    if (category != null) {
      data['category'] = category.toJson();
    }
    data['share_url'] = shareUrl;
    if (gallery != null) {
      data['gallery'] = gallery.map((v) => v.toJson()).toList();
    }
    if (suitable != null) {
      data['suitable'] = suitable.map((v) => v.toJson()).toList();
    }
    data['note'] = note;
    if (openTime != null) {
      data['open_time'] = openTime.map((v) => v.toJson()).toList();
    }
    return data;
  }

  factory PlaceModel.convertFromSaveItem(SaveItemModel itemModel) {
    final placeModel = PlaceModel(
      id: itemModel.id,
      title: itemModel.title,
      location: itemModel.location,
      image: itemModel.image,
      thumb: itemModel.thumb,
      isFavorite: itemModel.isFavorite,
      rate: itemModel.rate,
      openTime: itemModel.openTime,
      category: itemModel.category,
      shareUrl: itemModel.shareUrl,
      suitable: itemModel.suitable,
      gallery: itemModel.gallery,
      note: itemModel.note,
    );
    return placeModel;
  }

  factory PlaceModel.convertFromSearchModel(AmenityModel amenityModel) {
    final model = amenityModel.parent;
    final placeModel = PlaceModel(
      id: model.id,
      title: model.title,
      location: model.location,
      image: model.image,
      thumb: model.thumb,
      isFavorite: model.isFavorite,
      rate: model.rate,
      openTime: model.openTime,
      category: model.category,
      shareUrl: model.shareUrl,
      suitable: model.suitable,
      gallery: model.gallery,
      note: model.note,
    );
    return placeModel;
  }
}

import '../../utils/log_utils.dart';

import 'places_model.dart';
import 'suggestion.dart';

class AmenityDetailModel extends AmenityInfo {
  String shortDescription;
  String thumb;
  String phoneNumber;
  String rate;
  dynamic totalReview;
  List<PlaceModel> places;
  bool isFavorite;
  String category;

  AmenityDetailModel.fromJson(Map<String, dynamic> json) {
    doParseFromJson(json);
    try {
      thumb = json['thumb'];
      phoneNumber = json['phone_number'];
      suitableAge = json['suitable_age'];
      rate = json['rate'];
      totalReview = json['total_review'];
      if (json['places'] != null) {
        places = <PlaceModel>[];
        json['places'].forEach((v) {
          places.add(PlaceModel.fromJson(v));
        });
      }
      isFavorite = json['is_favorite'];
      category = json['category'];
      shortDescription = json['short_description'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['short_description'] = shortDescription;
    data['thumb'] = thumb;
    data['phone_number'] = phoneNumber;
    data['suitable_age'] = suitableAge;
    data['rate'] = rate;
    data['total_review'] = totalReview;
    if (places != null) {
      data['places'] = places.map((v) => v.toJson()).toList();
    }
    data['is_favorite'] = isFavorite;
    data['category'] = category;
    return data;
  }
}

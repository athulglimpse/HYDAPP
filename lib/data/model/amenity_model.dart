import '../../utils/log_utils.dart';

import 'search_amenities_model.dart';

class AmenityModel {
  String lat;
  String long;
  int id;
  String street;
  String locationAt;
  String address;
  String distance;
  SearchAmenitiesModel parent;

  AmenityModel({
    this.lat,
    this.long,
    this.id,
    this.street,
    this.parent,
    this.locationAt,
    this.address,
    this.distance,
  });

  AmenityModel.fromJson(Map<String, dynamic> json) {
    try {
      lat = json['lat'];
      long = json['long'];
      id = json['id'];
      if (json['parent'] is Map) {
        parent = SearchAmenitiesModel.fromJson(json['parent']);
      }
      street = json['street'];
      locationAt = json['location_at'];
      address = json['address'];
      distance = json['distance'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    data['longitude'] = long;
    data['id'] = id;
    if (parent != null) {
      data['parent'] = parent.toJson();
    }
    data['street'] = street;
    data['location_at'] = locationAt;
    data['address'] = address;
    data['distance'] = distance;
    return data;
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/amenity_model.dart';
import 'prefs/app_preferences.dart';

abstract class LocationLocalDataSource {
  List<AmenityModel> getNearBy();

  void saveNearBy(List<AmenityModel> amenities);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final AppPreferences appPreferences;

  LocationLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<AmenityModel> getNearBy() {
    try {
      final jsonString = appPreferences.getNearBy();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final listAmenities =
            strMap.map((v) => AmenityModel.fromJson(v)).toList();
        return listAmenities;
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void saveNearBy(List<AmenityModel> amenities) {
    final str = amenities.map((v) => v.toJson()).toList();
    return appPreferences.saveNearBy(json.encode(str));
  }
}

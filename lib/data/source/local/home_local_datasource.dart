import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/activity_model.dart';
import '../../model/area_item.dart';
import '../../model/community_model.dart';
import '../../model/suggestion.dart';
import '../../model/weather_info.dart';
import 'prefs/app_preferences.dart';

abstract class HomeLocalDataSource {
  List<AreaItem> getExperiences();

  WeatherInfo getWeatherInfo();

  CommunityModel getCommunityListInfo();

  List<AmenityInfo> getAmenities();

  void saveAmenitiesInfo(List<AmenityInfo> amenities);

  void saveExperiences(List<AreaItem> listAreas);

  void saveCommunityListInfo(CommunityModel communityModel);

  void saveWeatherInfo(WeatherInfo weatherInfo);

  List<ActivityModel> getActivities();

  void saveActivities(List<ActivityModel> items);


}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final AppPreferences appPreferences;

  HomeLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<AreaItem> getExperiences() {
    try {
      final jsonString = appPreferences.getExperiences();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final listAreas = strMap.map((v) => AreaItem.fromJson(v)).toList();
        return listAreas;
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
  void saveExperiences(List<AreaItem> listAreas) {
    final str = listAreas.map((v) => v.toJson()).toList();
    return appPreferences.saveExperiences(json.encode(str));
  }

  @override
  WeatherInfo getWeatherInfo() {
    try {
      final jsonString = appPreferences.getWeatherInfo();
      if (jsonString != null) {
        return WeatherInfo.fromJson(json.decode(jsonString));
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
  void saveWeatherInfo(WeatherInfo weatherInfo) {
    return appPreferences.saveWeatherInfo(json.encode(weatherInfo));
  }

  @override
  CommunityModel getCommunityListInfo() {
    try {
      final jsonString = appPreferences.getCommunities();
      if (jsonString != null) {
        return CommunityModel.fromJson(json.decode(jsonString));
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
  void saveCommunityListInfo(CommunityModel communityModel) {
    return appPreferences.saveCommunities(json.encode(communityModel.toJson()));
  }

  @override
  List<AmenityInfo> getAmenities() {
    try {
      final jsonString = appPreferences.getAmenities();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final listAmenities =
            strMap.map((v) => AmenityInfo.fromJson(v)).toList();
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
  void saveAmenitiesInfo(List<AmenityInfo> amenities) {
    final str = amenities.map((v) => v.toJson()).toList();
    return appPreferences.saveAmenities(json.encode(str));
  }

  @override
  List<ActivityModel> getActivities() {
    try {
      final jsonString = appPreferences.getActivities();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final items =
        strMap.map((v) => ActivityModel.fromJson(v)).toList();
        return items;
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
  void saveActivities(List<ActivityModel> items) {
    final str = items.map((v) => v.toJson()).toList();
    return appPreferences.saveActivities(json.encode(str));
  }
}

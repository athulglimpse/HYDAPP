import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/recent_model.dart';

import '../../model/amenity_model.dart';
import 'prefs/app_preferences.dart';

abstract class SearchLocalDataSource {
  List<RecentModel> getRecentSearch();

  void saveRecentSearch(List<RecentModel> amenities);
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final AppPreferences appPreferences;

  SearchLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<RecentModel> getRecentSearch() {
    try {
      final jsonString = appPreferences.getRecentList();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final data = strMap.map((v) => RecentModel.fromJson(v)).toList();
        return data;
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
  void saveRecentSearch(List<RecentModel> items) {
    final str = items.map((v) => v.toJson()).toList();
    return appPreferences.saveRecentList(json.encode(str));
  }
}

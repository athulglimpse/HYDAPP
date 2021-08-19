import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/activity_model.dart';

import 'prefs/app_preferences.dart';

abstract class ActivityLocalDataSource {
  ///Local Data
  ActivityModel getActivityDetail(String id);

  List<ActivityModel> getActivityAlsoLike({String id});

  void saveActivityDetail(ActivityModel activityDetailModel);

  void saveActivityAlsoLike(List<ActivityModel> activity, String id);
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final AppPreferences appPreferencesImpl;

  ActivityLocalDataSourceImpl({@required this.appPreferencesImpl});

  @override
  List<ActivityModel> getActivityAlsoLike({String id}) {
    try {
      final jsonString = appPreferencesImpl.getActivityAlsoLike(id: id);
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final listAmenities =
            strMap.map((v) => ActivityModel.fromJson(v)).toList();
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
  ActivityModel getActivityDetail(String id) {
    try {
      final jsonString = appPreferencesImpl.getActivityDetail(id);
      if (jsonString != null) {
        return ActivityModel.fromJson(json.decode(jsonString));
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
  void saveActivityAlsoLike(List<ActivityModel> items, String id) {
    final str = items.map((v) => v.toJson()).toList();
    return appPreferencesImpl.saveActivityAlsoLike(json.encode(str), id);
  }

  @override
  void saveActivityDetail(ActivityModel activityModel) {
    final id = activityModel?.id.toString() ?? '';
    return appPreferencesImpl.saveActivityDetail(
        json.encode(activityModel), id);
  }
}

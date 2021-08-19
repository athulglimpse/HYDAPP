import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/notification_history_model.dart';
import '../../model/notification_setting_model.dart';
import 'prefs/app_preferences.dart';

abstract class NotificationLocalDataSource {
  List<NotificationSettingModel> getListNotificationItems();

  void saveListNotificationItems(List<NotificationSettingModel> list);

  List<NotificationHistoryModel> getListNotificationHistoryItems();

  void saveListNotificationHistoryItems(List<NotificationHistoryModel> list);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final AppPreferences appPreferences;

  NotificationLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<NotificationSettingModel> getListNotificationItems() {
    final jsonString = appPreferences.getNotificationSetting();
    if (jsonString != null) {
      final List<dynamic> strMap = json.decode(jsonString);
      final interestInfs =
          strMap.map((v) => NotificationSettingModel.fromJson(v)).toList();
      return interestInfs;
    } else {
      return null;
    }
  }

  @override
  void saveListNotificationItems(List<NotificationSettingModel> list) {
    final str = list.map((v) => v.toJson()).toList();
    return appPreferences.saveNotificationSetting(json.encode(str));
  }

  @override
  void saveListNotificationHistoryItems(List<NotificationHistoryModel> list) {
    final str = list.map((v) => v.toJson()).toList();
    return appPreferences.saveNotificationHistory(json.encode(str));
  }

  @override
  List<NotificationHistoryModel> getListNotificationHistoryItems() {
    final jsonString = appPreferences.getNotificationHistory();
    if (jsonString != null) {
      final List<dynamic> strMap = json.decode(jsonString);
      final interestInfs =
          strMap.map((v) => NotificationHistoryModel.fromJson(v)).toList();
      return interestInfs;
    } else {
      return null;
    }
  }
}

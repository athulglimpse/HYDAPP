import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ui/assets/asset_see_all/asset_see_all_grid_page.dart';
import 'app_preferences.dart';

class AppPreferencesImpl extends AppPreferences {
  final SharedPreferences sharedPreferences;
  final Box box;

  AppPreferencesImpl({
    @required this.sharedPreferences,
    @required this.box,
  });

  @override
  String getActivityAlsoLike({String id}) {
    return box.get(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE + '_' + id);
  }

  @override
  String getActivityDetail(String id) {
    return box.get(AppPreferences.CACHED_ACTIVITY_DETAIL + '_' + id);
  }

  @override
  void saveActivityAlsoLike(String data, String id) {
    box.put(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE, data + '_' + id);
  }

  @override
  void saveActivityDetail(String data, String id) {
    box.put(AppPreferences.CACHED_ACTIVITY_DETAIL + '_' + id, data);
  }

  @override
  String getAsset(ViewAssetType viewAssetType) {
    return box
        .get(AppPreferences.CACHED_ASSETS + '_' + viewAssetType.toString());
  }

  @override
  void saveAsset(String data, ViewAssetType viewAssetType) {
    box.put(
        AppPreferences.CACHED_ASSETS + '_' + viewAssetType.toString(), data);
  }

  @override
  String getAppConfig() {
    return box.get(AppPreferences.CACHED_APP_CONFIG);
  }

  @override
  void saveAppConfig(String data) {
    box.put(AppPreferences.CACHED_APP_CONFIG, data);
  }

  @override
  String getEventCategories() {
    return box.get(AppPreferences.CACHED_EVENT_CATEGORIES);
  }

  @override
  String getEventDetail(String id) {
    return box.get(AppPreferences.CACHED_EVENT_DETAIL + '_' + id);
  }

  @override
  String getEvents() {
    return box.get(AppPreferences.CACHED_EVENTS);
  }

  @override
  void saveEventCategories(String data) {
    box.put(AppPreferences.CACHED_EVENT_CATEGORIES, data);
  }

  @override
  void saveEventDetail(String data, String id) {
    box.put(AppPreferences.CACHED_EVENT_DETAIL + '_' + id, data);
  }

  @override
  void saveEvents(String data) {
    box.put(AppPreferences.CACHED_EVENTS, data);
  }

  @override
  String getAmenities() {
    return box.get(AppPreferences.CACHED_AMENITIES_INFO);
  }

  @override
  String getCommunities() {
    return box.get(AppPreferences.CACHED_COMMUNITY_LIST_INFO);
  }

  @override
  String getExperiences() {
    return box.get(AppPreferences.CACHED_EXPERIENCES);
  }

  @override
  String getWeatherInfo() {
    return box.get(AppPreferences.CACHED_WEATHER_INFO);
  }

  @override
  void saveAmenities(String data) {
    box.put(AppPreferences.CACHED_AMENITIES_INFO, data);
  }

  @override
  void saveCommunities(String data) {
    box.put(AppPreferences.CACHED_COMMUNITY_LIST_INFO, data);
  }

  @override
  void saveExperiences(String data) {
    box.put(AppPreferences.CACHED_EXPERIENCES, data);
  }

  @override
  void saveWeatherInfo(String data) {
    box.put(AppPreferences.CACHED_WEATHER_INFO, data);
  }

  @override
  String getPersonalizationItems() {
    return box.get(AppPreferences.CACHED_PERSONALIZATION_ITEMS);
  }

  @override
  void savePersonalizationItems(String data) {
    box.put(AppPreferences.CACHED_PERSONALIZATION_ITEMS, data);
  }

  @override
  String getNotificationSetting() {
    return box.get(AppPreferences.CACHED_NOTIFICATION_ITEMS);
  }

  @override
  void saveNotificationSetting(String data) {
    box.put(AppPreferences.CACHED_NOTIFICATION_ITEMS, data);
  }

  @override
  String getNotificationHistory() {
    return box.get(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS);
  }

  @override
  void saveNotificationHistory(String data) {
    box.put(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS, data);
  }

  @override
  String getPostComment(String id) {
    return box.get(AppPreferences.CACHED_POST_COMMENT + '_' + id);
  }

  @override
  String getPostDetail(String id) {
    return box.get(AppPreferences.CACHED_POST_DETAIL + '_' + id);
  }

  @override
  void savePostComment(String data, String id) {
    box.put(AppPreferences.CACHED_POST_COMMENT + '_' + id, data);
  }

  @override
  void savePostDetail(String data, String id) {
    box.put(AppPreferences.CACHED_POST_DETAIL + '_' + id, data);
  }

  @override
  String getStaticContent() {
    return box.get(AppPreferences.CACHED_STATIC_CONTENTS);
  }

  @override
  void saveStaticContent(String data) {
    box.put(AppPreferences.CACHED_STATIC_CONTENTS, data);
  }

  @override
  String getAccessToken() {
    return box.get(AppPreferences.CACHED_ACCESS_TOKEN);
  }

  @override
  String getUserInfo() {
    return box.get(AppPreferences.CACHED_CURRENT_USER);
  }

  @override
  void saveAccessToken(String data) {
    box.put(AppPreferences.CACHED_ACCESS_TOKEN, data);
  }

  @override
  void saveUserInfo(String data) {
    box.put(AppPreferences.CACHED_CURRENT_USER, data);
  }

  @override
  Future<void> clearUserData() async {
    if (box.containsKey(AppPreferences.CACHED_CURRENT_USER)) {
      await box.delete(AppPreferences.CACHED_CURRENT_USER);
    }
    if (box.containsKey(AppPreferences.CACHED_ACCESS_TOKEN)) {
      await box.delete(AppPreferences.CACHED_ACCESS_TOKEN);
    }
    if (box.containsKey(AppPreferences.CACHED_APP_NEAR_BY)) {
      await box.delete(AppPreferences.CACHED_APP_NEAR_BY);
    }
    if (box.containsKey(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE)) {
      await box.delete(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE);
    }  if (box.containsKey(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE)) {
      await box.delete(AppPreferences.CACHED_ACTIVITY_ALSO_LIKE);
    }
    if (box.containsKey(AppPreferences.CACHED_ASSETS)) {
      await box.delete(AppPreferences.CACHED_ASSETS);
    }
    if (box.containsKey(AppPreferences.CACHED_EVENTS)) {
      await box.delete(AppPreferences.CACHED_EVENTS);
    }
    if (box.containsKey(AppPreferences.CACHED_COMMUNITY_LIST_INFO)) {
      await box.delete(AppPreferences.CACHED_COMMUNITY_LIST_INFO);
    }
    if (box.containsKey(AppPreferences.CACHED_AMENITIES_INFO)) {
      await box.delete(AppPreferences.CACHED_AMENITIES_INFO);
    }
    if (box.containsKey(AppPreferences.CACHED_NOTIFICATION_ITEMS)) {
      await box.delete(AppPreferences.CACHED_NOTIFICATION_ITEMS);
    }
    if (box.containsKey(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS)) {
      await box.delete(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS);
    }
    if (box.containsKey(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS)) {
      await box.delete(AppPreferences.CACHED_NOTIFICATION_HISTORY_ITEMS);
    }
  }

  @override
  String getMyLocation() {
    return box.get(AppPreferences.CACHED_MY_LOCATION);
  }

  @override
  void saveMyLocation(String locationData) {
    box.put(AppPreferences.CACHED_MY_LOCATION, locationData);
  }

  @override
  String getNearBy() {
    return box.get(AppPreferences.CACHED_APP_NEAR_BY);
  }

  @override
  void saveNearBy(String data) {
    box.put(AppPreferences.CACHED_APP_NEAR_BY, data);
  }

  @override
  String getHelpItems() {
    return box.get(AppPreferences.CACHED_APP_HELP_ITEMS);
  }

  @override
  String getReportItems() {
    return box.get(AppPreferences.CACHED_APP_REPORT_ITEMS);
  }

  @override
  void saveHelpItems(String data) {
    box.put(AppPreferences.CACHED_APP_HELP_ITEMS, data);
  }

  @override
  void saveReportItems(String data) {
    box.put(AppPreferences.CACHED_APP_REPORT_ITEMS, data);
  }

  @override
  String getRecentList() {
    return box.get(AppPreferences.CACHED_APP_RECENT_ITEMS);
  }

  @override
  void saveRecentList(String data) {
    box.put(AppPreferences.CACHED_APP_RECENT_ITEMS, data);
  }

  @override
  String getActivities() {
    return box.get(AppPreferences.CACHED_APP_ACTIVITIES);
  }

  @override
  void saveActivities(String data) {
    box.put(AppPreferences.CACHED_APP_ACTIVITIES, data);
  }

  @override
  String getAssetDetail(String id) {
    return box.get(AppPreferences.CACHED_ASSETS_DETAIL + '_' + id);
  }

  @override
  void saveAssetDetail(String data, String id) {
    box.put(AppPreferences.CACHED_ASSETS_DETAIL + '_' + id, data);
  }

  @override
  String getMapDefault() {
    return box.get(AppPreferences.CACHED_MAP_DEFAULT,
        defaultValue: AppPreferences.APPLE_MAP);
  }

  @override
  void saveMapDefault(String data) {
    box.put(AppPreferences.CACHED_MAP_DEFAULT, data);
  }

  @override
  void saveAmenityDetail(String data, String id) {
    box.put(AppPreferences.CACHED_AMENITIES_INFO + '_' + id, data);
  }

  @override
  String getAmenityDetail(String id) {
    return box.get(AppPreferences.CACHED_AMENITIES_INFO + '_' + id,
        defaultValue: AppPreferences.APPLE_MAP);
  }
}

import '../../../../ui/assets/asset_see_all/asset_see_all_grid_page.dart';

abstract class AppPreferences {
  void saveMapDefault(String data);

  String getMapDefault();

  void saveActivityDetail(String data, String id);

  String getActivityDetail(String id);

  void saveAmenityDetail(String data, String id);

  String getAmenityDetail(String id);

  void saveActivityAlsoLike(String data, String id);

  String getActivityAlsoLike({String id});

  void saveAsset(String data, ViewAssetType viewAssetType);

  String getAsset(ViewAssetType viewAssetType);

  void saveAssetDetail(String data, String id);

  String getAssetDetail(String id);

  void saveAppConfig(String data);

  String getAppConfig();

  void saveEventDetail(String data, String id);

  String getEventDetail(String id);

  void saveEvents(String data);

  String getEvents();

  void saveEventCategories(String data);

  String getEventCategories();

  void saveExperiences(String data);

  String getExperiences();

  void saveWeatherInfo(String data);

  String getWeatherInfo();

  void saveCommunities(String data);

  String getCommunities();

  void saveAmenities(String data);

  String getAmenities();

  void saveActivities(String data);

  String getActivities();

  void savePersonalizationItems(String data);

  String getPersonalizationItems();

  void saveNotificationSetting(String data);

  String getNotificationSetting();

  void saveNotificationHistory(String data);

  String getNotificationHistory();

  void savePostDetail(String data, String id);

  String getPostDetail(String id);

  void savePostComment(String data, String postId);

  String getPostComment(String postId);

  void saveMyLocation(String locationData);

  String getMyLocation();

  void saveStaticContent(String data);

  String getStaticContent();

  void saveUserInfo(String data);

  String getUserInfo();

  void saveAccessToken(String data);

  String getAccessToken();

  Future<void> clearUserData();

  void saveNearBy(String data);

  String getNearBy();

  void saveHelpItems(String data);

  String getHelpItems();

  void saveReportItems(String data);

  String getReportItems();

  void saveRecentList(String data);

  String getRecentList();

  static const CACHED_MAP_DEFAULT = 'CACHED_MAP_DEFAULT';
  static const CACHED_APP_RECENT_ITEMS = 'CACHED_APP_RECENT_ITEMS';
  static const CACHED_APP_ACTIVITIES = 'CACHED_APP_ACTIVITIES';
  static const CACHED_APP_HELP_ITEMS = 'CACHED_APP_HELP_ITEMS';
  static const CACHED_APP_REPORT_ITEMS = 'CACHED_APP_REPORT_ITEMS';
  static const CACHED_APP_NEAR_BY = 'CACHED_NEAR_BY';
  static const CACHED_APP_CONFIG = 'CACHED_CONFIG';
  static const CACHED_MY_LOCATION = 'CACHED_MY_LOCATION';
  static const CACHED_ACTIVITY_DETAIL = 'CACHED_ACTIVITY_DETAIL';
  static const CACHED_ACTIVITY_ALSO_LIKE = 'CACHED_ACTIVITY_ALSO_LIKE';
  static const CACHED_ASSETS = 'CACHED_ASSETS';
  static const CACHED_ASSETS_DETAIL = 'CACHED_ASSETS_DETAIL';
  static const CACHED_EVENT_DETAIL = 'CACHED_EVENT_DETAIL';
  static const CACHED_EVENTS = 'CACHED_EVENTS';
  static const CACHED_EVENT_CATEGORIES = 'CACHED_EVENT_CATEGORIES';

  static const CACHED_EXPERIENCES = 'CACHED_EXPERIENCES';
  static const CACHED_WEATHER_INFO = 'CACHED_WEATHER_INFO';
  static const CACHED_COMMUNITY_LIST_INFO = 'CACHED_COMMUNITY_LIST_INFO';
  static const CACHED_AMENITIES_INFO = 'CACHED_AMENITIES_INFO';

  static const CACHED_NOTIFICATION_ITEMS = 'CACHED_NOTIFICATION_ITEMS';
  static const CACHED_NOTIFICATION_HISTORY_ITEMS =
      'CACHED_NOTIFICATION_HISTORY_ITEMS';
  static const CACHED_PERSONALIZATION_ITEMS = 'CACHED_PERSONALIZATION_ITEMS';

  static const CACHED_POST_DETAIL = 'CACHED_POST_DETAIL';
  static const CACHED_POST_COMMENT = 'CACHED_POST_COMMENT';
  static const CACHED_STATIC_CONTENTS = 'CACHED_STATIC_CONTENTS';
  static const CACHED_CURRENT_USER = 'CACHED_CURRENT_USER';
  static const CACHED_ACCESS_TOKEN = 'CACHED_ACCESS_TOKEN';

  static const APPLE_MAP = 'APPLE_MAP';
  static const GOOGLE_MAP = 'GOOGLE_MAP';
  static const WAZE_MAP = 'WAZE_MAP';
}

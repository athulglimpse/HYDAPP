import 'package:equatable/equatable.dart';
import 'package:marvista/common/di/injection/injector.dart';
import 'package:marvista/data/repository/home_repository.dart';
import 'package:marvista/data/source/local/prefs/app_preferences.dart';
import 'package:meta/meta.dart';

import '../../../data/model/language.dart';
import '../../../data/model/notification_setting_model.dart';
import '../../../data/model/static_content.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';

@immutable
class SettingsState extends Equatable {
  final Map<String, Map> filterOptSelected;
  final List<Language> arrLanguage;
  final List<NotificationSettingModel> notificationItemList;
  final bool success;
  final StaticContent staticContent;
  final String errorMessage;
  final bool isNotification;
  final bool isAppleMapEnable;
  final bool isGoogleMapEnable;
  final bool isWazeMapEnable;
  final UserInfo userInfo;
  final String refreshTime;
  SettingsState({
    this.arrLanguage,
    this.filterOptSelected,
    this.refreshTime,
    this.staticContent,
    this.success,
    this.isAppleMapEnable,
    this.isGoogleMapEnable,
    this.isWazeMapEnable,
    this.userInfo,
    this.isNotification,
    this.notificationItemList,
    this.errorMessage,
  });

  factory SettingsState.initial(
    HomeRepository homeRepository,
    NotificationRepository notificationRepository,
    UserRepository userRepository,
    StaticContentRepository staticContentRepository,
  ) {
    final notificationItemList =
        notificationRepository?.getLocalListNotificationItems() ?? [];
    final notificationSettingModel = notificationItemList
        .firstWhere((element) => element.status == 1, orElse: () => null);
    final mapDefault = sl<AppPreferences>().getMapDefault();
    return SettingsState(
        userInfo: userRepository.getCurrentUser(),
        notificationItemList: notificationItemList,
        filterOptSelected: const <String, Map>{},
        isAppleMapEnable: mapDefault == AppPreferences.APPLE_MAP,
        isGoogleMapEnable: mapDefault == AppPreferences.GOOGLE_MAP,
        isWazeMapEnable: mapDefault == AppPreferences.WAZE_MAP,
        staticContent: staticContentRepository.getLocalStaticContent(),
        isNotification: notificationSettingModel != null,
        arrLanguage: null);
  }

  SettingsState copyWith({
    Map filterOptSelected,
    List<Language> arrLanguage,
    bool success,
    bool isAppleMapEnable,
    bool isGoogleMapEnable,
    bool isWazeMapEnable,
    String refreshTime,
    String errorMessage,
    String policyPrivacy,
    StaticContent staticContent,
    String termCondition,
    bool isNotification,
    List<NotificationSettingModel> notificationItemList,
  }) {
    return SettingsState(
        isAppleMapEnable: isAppleMapEnable ?? this.isAppleMapEnable,
        isGoogleMapEnable: isGoogleMapEnable ?? this.isGoogleMapEnable,
        isWazeMapEnable: isWazeMapEnable ?? this.isWazeMapEnable,
        filterOptSelected: filterOptSelected ?? this.filterOptSelected,
        success: success ?? this.success,
        refreshTime: refreshTime ?? this.refreshTime,
        staticContent: staticContent ?? this.staticContent,
        isNotification: isNotification ?? this.isNotification,
        userInfo: userInfo,
        notificationItemList: notificationItemList ?? this.notificationItemList,
        errorMessage: errorMessage ?? this.errorMessage,
        arrLanguage: arrLanguage ?? this.arrLanguage);
  }

  SettingsState clearAll() {
    return SettingsState(
      filterOptSelected: const <String, Map>{},
    );
  }

  @override
  List<Object> get props => [
        filterOptSelected,
        notificationItemList,
        success,
        isWazeMapEnable,
        isGoogleMapEnable,
        refreshTime,
        isAppleMapEnable,
        userInfo,
        staticContent,
        isNotification,
        errorMessage,
        arrLanguage,
      ];

  @override
  String toString() {
    return '''MyFormState {
      filterOptSelected: $filterOptSelected,
      notificationItemList: $notificationItemList,
      userInfo: $userInfo,
      success: $success,
      isNotification: $isNotification,
      errorMessage: $errorMessage,
    }''';
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:marvista/data/repository/help_report_repository.dart';
import 'package:marvista/data/repository/home_repository.dart';
import 'package:marvista/data/repository/personalize_repository.dart';
import 'package:marvista/utils/app_const.dart';
import '../../../common/di/injection/injector.dart';
import '../../../data/model/language.dart';
import '../../../data/model/notification_setting_model.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/local/prefs/app_preferences.dart';
import '../../../data/source/success.dart';
import '../../../utils/app_const.dart';
import '../../../utils/firebase_wrapper.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository userRepository;
  final HomeRepository homeRepository;
  final StaticContentRepository staticContentRepository;
  final NotificationRepository notificationRepository;
  final AppPreferences appPreferences;
  final PersonalizeRepository personalizeRepository;
  final HelpAndReportRepository helpAndReportRepository;
  final FirebaseWrapper _firebaseWrapper = sl<FirebaseWrapper>();
  SettingsBloc(
      {@required this.userRepository,
      this.homeRepository,
      this.staticContentRepository,
      this.appPreferences,
      this.notificationRepository,
      this.personalizeRepository,
      this.helpAndReportRepository})
      : super(SettingsState.initial(homeRepository, notificationRepository,
            userRepository, staticContentRepository));
            
  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is LoadLanguage) {
      final result = await staticContentRepository.getLanguage();
      yield* _handleGetLanguageResult(result);
    } else if (event is FetchNotificationData) {
      final result = await notificationRepository.fetchNotificationSetting();
      yield* _handleFetchNotificationResult(result);
    } else if (event is OnSetAppleMapDefault) {
      appPreferences.saveMapDefault(AppPreferences.APPLE_MAP);
      yield state.copyWith(
          isAppleMapEnable: true,
          isGoogleMapEnable: false,
          isWazeMapEnable: false);
    } else if (event is OnChangeLanguage) {
      await Future.wait([
        homeRepository.fetchListExperiences(),
        personalizeRepository.fetchListPersonalizeItems(),
        staticContentRepository.fetchStaticContent(),
        helpAndReportRepository.fetchHelpItems(),
        helpAndReportRepository.fetchReportItems(),
      ]);
      yield state.copyWith(refreshTime: DateTime.now().toIso8601String());
    } else if (event is OnSetGoogleMapDefault) {
      appPreferences.saveMapDefault(AppPreferences.GOOGLE_MAP);
      yield state.copyWith(
          isAppleMapEnable: false,
          isGoogleMapEnable: true,
          isWazeMapEnable: false);
    } else if (event is OnSetWazeMapDefault) {
      appPreferences.saveMapDefault(AppPreferences.WAZE_MAP);
      yield state.copyWith(
          isAppleMapEnable: false,
          isGoogleMapEnable: false,
          isWazeMapEnable: true);
    } else if (event is OnSubmitNotificationSetting) {
      state.notificationItemList.forEach((value) {
        value.status = event.isNotification ? 1 : 0;
      });
      yield state.copyWith(success: true, isNotification: event.isNotification);
      final result = await notificationRepository
          .submitNotificationSetting(state.notificationItemList);
      notificationRepository
          .saveListNotificationItems(state.notificationItemList);
      yield* _handleSubmitNotificationResult(result, event.isNotification);
    }
  }

  Stream<SettingsState> _handleFetchNotificationResult(
      Either<Failure, List<NotificationSettingModel>> result) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        final notificationSettingModel = value
            ?.firstWhere((element) => element.status == 1, orElse: () => null);
        return state.copyWith(
          notificationItemList: value,
          isNotification: notificationSettingModel != null,
        );
      },
    );
  }

  Stream<SettingsState> _handleGetLanguageResult(
      Either<Failure, List<Language>> result) async* {
    yield result.fold(
      (failure) => state,
      (language) => state.copyWith(arrLanguage: language),
    );
  }

  Stream<SettingsState> _handleSubmitNotificationResult(
      Either<Failure, Success> result, bool isNotification) async* {
    yield result.fold(
        (failure) => state.copyWith(
              success: false,
              errorMessage: (failure as RemoteDataFailure).errorMessage,
            ), (value) {
      changeNotification(state.notificationItemList);
      return state.copyWith(success: true, isNotification: isNotification);
    });
  }

  void changeNotification(List<NotificationSettingModel> notificationItemList) {
    notificationItemList.forEach((element) {
      if (element.isOn) {
        _firebaseWrapper
            .subscribeToTopic(DEFAULT_TOPICS_MARVISTA_ANNOUNCEMENTS);
        _firebaseWrapper.subscribeToTopic(DEFAULT_TOPICS_EVENT);
        _firebaseWrapper.subscribeToTopic(DEFAULT_TOPICS_COMMUNITY_POSTS);
        _firebaseWrapper.subscribeToTopic(DEFAULT_TOPICS_APPROVED_POSTS);
      } else {
        _firebaseWrapper
            .unsubscribeFromTopic(DEFAULT_TOPICS_MARVISTA_ANNOUNCEMENTS);
        _firebaseWrapper.unsubscribeFromTopic(DEFAULT_TOPICS_EVENT);
        _firebaseWrapper.unsubscribeFromTopic(DEFAULT_TOPICS_COMMUNITY_POSTS);
        _firebaseWrapper.unsubscribeFromTopic(DEFAULT_TOPICS_APPROVED_POSTS);
      }
    });
  }
}

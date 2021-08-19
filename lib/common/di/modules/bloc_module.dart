import '../../../ui/assets/asset_detail/bloc/asset_detail_bloc.dart';
import '../../../ui/assets/asset_see_all/bloc/asset_see_all_bloc.dart';
import '../../../ui/base/bloc/base_bloc.dart';
import '../../../ui/change_password/bloc/change_password_bloc.dart';
import '../../../ui/community/community_detail/bloc/community_detail_bloc.dart';
import '../../../ui/community/community_post_photo/bloc/community_post_photo_bloc.dart';
import '../../../ui/community/community_see_all/bloc/community_see_all_bloc.dart';
import '../../../ui/community/community_write_review/bloc/community_write_review_bloc.dart';
import '../../../ui/congratulation_register/bloc/congratulation_regiter_bloc.dart';
import '../../../ui/deactivate_account/bloc/deactivate_account_bloc.dart';
import '../../../ui/event/base/bloc/event_bloc.dart';
import '../../../ui/event/detail/bloc/event_detail_bloc.dart';
import '../../../ui/filter/bloc/filter_bloc.dart';
import '../../../ui/forgotpassword/bloc/forgot_password_bloc.dart';
import '../../../ui/getstarted/bloc/started_bloc.dart';
import '../../../ui/help/bloc/help_bloc.dart';
import '../../../ui/home/bloc/home_bloc.dart';
import '../../../ui/home/search/bloc/homesearch_bloc.dart';
import '../../../ui/legalandpolicy/bloc/legal_policy_bloc.dart';
import '../../../ui/login/bloc/bloc.dart';
import '../../../ui/main/bloc/main_bloc.dart';
import '../../../ui/map/bloc/map_page_bloc.dart';
import '../../../ui/more/bloc/more_bloc.dart';
import '../../../ui/my_community/bloc/my_community_bloc.dart';
import '../../../ui/notification_history/bloc/notification_history_bloc.dart';
import '../../../ui/notification_setting/bloc/notification_setting_bloc.dart';
import '../../../ui/personalization/bloc/personalization_bloc.dart';
import '../../../ui/profile/bloc/profile_bloc.dart';
import '../../../ui/register/bloc/register_bloc.dart';
import '../../../ui/register_opt/bloc/bloc.dart';
import '../../../ui/report/bloc/report_bloc.dart';
import '../../../ui/save_item/bloc/save_item_bloc.dart';
import '../../../ui/setting/bloc/settings_bloc.dart';
import '../../../ui/splash/bloc/splash_bloc.dart';
import '../../../ui/unity_map/bloc/unity_map_bloc.dart';
import '../../../ui/verifycode/bloc/verify_code_bloc.dart';
import '../../../ui/weekend_activity/detail/bloc/weekend_activity_detail_bloc.dart';
import '../../../ui/weekend_activity/see_all/bloc/weekend_activity_see_all_bloc.dart';
import '../injection/injector.dart';

class BlocModule extends DIModule {
  @override
  Future<void> provides() async {
    sl.registerLazySingleton(() => BaseBloc(userRepository: sl()));

    sl.registerFactory(() => RegisterOptBloc(
        userRepository: sl(),
        staticContentRepository: sl(),
        configRepository: sl()));
    sl.registerFactory(() => MainBloc());
    sl.registerFactory(
      () => HomeBloc(
          assetRepository: sl(),
          homeRepository: sl(),
          userRepository: sl(),
          locationRepository: sl(),
          homeInteract: sl(),
          eventRepository: sl(),
          postRepository: sl(),
          configRepository: sl()),
    );
    sl.registerFactory(() => HomeSearchBloc(
          searchRepository: sl(),
        ));
    sl.registerFactory(() => MapPageBloc(
          homeRepository: sl(),
          assetRepository: sl(),
          locationRepository: sl(),
        ));
    sl.registerFactory(() => LoginBloc(userRepository: sl()));
    sl.registerFactory(
        () => EventBloc(eventRepository: sl(), postRepository: sl()));
    sl.registerFactory(() => CongratulationRegisterBloc());
    sl.registerFactory(() => ForgotPasswordBloc(userRepository: sl()));
    sl.registerFactory(() => VerifyCodeBloc(userRepository: sl()));
    sl.registerFactory(() => MoreBloc(userRepository: sl()));
    sl.registerFactory(() => EventDetailBloc(
        eventRepository: sl(),
        homeRepository: sl(),
        postRepository: sl(),
        userRepository: sl()));
    sl.registerFactory(() => WeekendActivitySeeAllBloc(homeRepository: sl()));
    sl.registerFactory(() => WeekendActivityDetailBloc(
        activityRepository: sl(), homeRepository: sl()));
    sl.registerFactory(() => CommunityDetailBloc(
        postRepository: sl(), userRepository: sl(), homeRepository: sl()));
    sl.registerFactory(() => CommunitySeeAllBloc(homeRepository: sl()));
    sl.registerFactory(
        () => ProfileBloc(userRepository: sl(), configRepository: sl()));
    sl.registerFactory(() => SettingsBloc(
        homeRepository: sl(),
        userRepository: sl(),
        staticContentRepository: sl(),
        appPreferences: sl(),
        notificationRepository: sl(),
        personalizeRepository: sl(),
        helpAndReportRepository: sl()));
    sl.registerFactory(() => HelpBloc(
          userRepository: sl(),
          configRepository: sl(),
          helpAndReportRepository: sl(),
        ));
    sl.registerFactory(() => LegalPolicyBloc());
    sl.registerFactory(() =>
        CommunityPostPhotoBloc(userRepository: sl(), locationRepository: sl()));
    sl.registerFactory(() => CommunityWriteReviewBloc(
        userRepository: sl(), assetRepository: sl(), postRepository: sl()));
    sl.registerFactory(() =>
        AssetSeeAllBloc(assetRepository: sl(), assetSeeAllInteract: sl()));
    sl.registerFactory(() => AssetDetailBloc(
        assetRepository: sl(), homeRepository: sl(), userRepository: sl()));

    sl.registerFactory(
        () => NotificationSettingBloc(notificationRepository: sl()));
    sl.registerFactory(() => NotificationHistoryBloc(
        notificationRepository: sl(), notificationHistoryInteract: sl()));
    sl.registerFactory(() => FilterBloc(userRepository: sl()));
    sl.registerFactory(() => StartedBloc(
        staticContentRepository: sl(),
        userRepository: sl(),
        homeRepository: sl(),
        personalizeRepository: sl(),
        helpAndReportRepository: sl()));
    sl.registerFactory(
        () => RegisterBloc(userRepository: sl(), configRepository: sl()));
    sl.registerFactory(() => SplashBloc(
        userRepository: sl(),
        configRepository: sl(),
        homeRepository: sl(),
        helpAndReportRepository: sl(),
        staticContentRepository: sl(),
        personalizeRepository: sl()));
    sl.registerFactory(() =>
        PersonalizationBloc(personalizeRepository: sl(), userRepository: sl()));
    sl.registerFactory(
        () => SaveItemBloc(profileRepository: sl(), homeRepository: sl()));
    sl.registerFactory(() => UnityMapBloc(
          homeRepository: sl(),
          assetRepository: sl(),
          locationRepository: sl(),
        ));
    sl.registerFactory(() =>
        DeactivateAccountBloc(profileRepository: sl(), userRepository: sl()));
    sl.registerFactory(() => ReportBloc(
          configRepository: sl(),
          helpAndReportRepository: sl(),
        ));
    sl.registerFactory(() => ChangePasswordBloc(userRepository: sl()));
    sl.registerFactory(
        () => MyCommunityBloc(userRepository: sl(), profileRepository: sl()));
  }
}

import 'package:flutter/material.dart';

import '../app.dart';
import '../common/di/injection/injector.dart';
import '../data/model/area_item.dart';
import '../ui/assets/asset_detail/asset_detail_page.dart';
import '../ui/assets/asset_see_all/asset_see_all_grid_page.dart';
import '../ui/assets/asset_see_all/asset_see_all_list_page.dart';
import '../ui/base/bloc/base_bloc.dart';
import '../ui/change_password/change_password_page.dart';
import '../ui/community/community_congratulation/community_congratulation_page.dart';
import '../ui/community/community_detail/community_detail_page.dart';
import '../ui/community/community_post_photo/community_post_photo_page.dart';
import '../ui/community/community_see_all/community_see_all_page.dart';
import '../ui/community/community_write_review/community_write_review_page.dart';
import '../ui/congratulation_register/congratulation_regiter_page.dart';
import '../ui/deactivate_account/deactivate_account_page.dart';
import '../ui/event/detail/event_detail_page.dart';
import '../ui/filter/filter_page.dart';
import '../ui/forgotpassword/forgot_password_page.dart';
import '../ui/getstarted/get_started_page.dart';
import '../ui/help/help_page.dart';
import '../ui/home/home_page.dart';
import '../ui/legalandpolicy/legal_policy_page.dart';
import '../ui/login/login_page.dart';
import '../ui/main/main_page.dart';
import '../ui/my_community/my_community_page.dart';
import '../ui/notification_history/notification_history_page.dart';
import '../ui/notification_setting/notification_setting_page.dart';
import '../ui/personalization/personalization_page.dart';
import '../ui/profile/profile_page.dart';
import '../ui/register/register_page.dart';
import '../ui/register_opt/register_opt_page.dart';
import '../ui/report/report_page.dart';
import '../ui/save_item/save_item_page.dart';
import '../ui/setting/settings_page.dart';
import '../ui/splash/splash_page.dart';
import '../ui/unity_map/unity_map_screen.dart';
import '../ui/verifycode/verify_code_page.dart';
import '../ui/weekend_activity/detail/weekend_activity_detail_page.dart';
import '../ui/weekend_activity/see_all/weekend_activity_see_all_page.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Application.currentContext = context;
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  // @override
  // Widget buildTransitions(BuildContext context, Animation<double> animation,
  //     Animation<double> secondaryAnimation, Widget child) {
  //   Application.currentContext = context;
  //   return super
  //       .buildTransitions(context, animation, secondaryAnimation, child);
  // }
}

class RouteArgument {
  static const String comeFrom = 'come_from';
  static const String type = 'type';
  static const String email = 'email';
  static const String token = 'token';
  static const String currentArea = 'current_area';
  static const String communityId = 'community_Id';
}

RouteFactory get myRoute => (RouteSettings settings) {
      switch (settings.name) {
        case HomePage.routeName:
          return MyCustomRoute(
            builder: (_) => HomePage(),
            settings: settings,
          );
        case FilterPage.routeName:
          AreaItem currentArea;
          final Map dataArg = settings.arguments;
          if (dataArg != null &&
              dataArg.containsKey(RouteArgument.currentArea)) {
            currentArea = dataArg[RouteArgument.currentArea];
          }
          return MyCustomRoute(
            builder: (_) => FilterPage(
              areaItem: currentArea,
              filterOptSelected: (dataArg?.containsKey('filter') ?? false)
                  ? dataArg['filter']
                  : null,
            ),
            settings: settings,
          );
        case SplashScreen.routeName:
          return MyCustomRoute(
            builder: (_) => SplashScreen(),
            settings: settings,
          );
        case WeekendActivitySeeAllScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => WeekendActivitySeeAllScreen(
              experienceId: dataArg['experId'],
            ),
            settings: settings,
          );
        case CommunityDetailScreen.routeName:
          final Map data = settings.arguments;
          return MyCustomRoute(
            builder: (_) => CommunityDetailScreen(
              communityPost: data.containsKey('data') ? data['data'] : null,
              id: data.containsKey('id') ? data['id'] : null,
            ),
            settings: settings,
          );
        case RegisterOptPage.routeName:
          return MyCustomRoute(
            builder: (_) => RegisterOptPage(),
            settings: settings,
          );
        case ForgotPasswordScreen.routeName:
          return MyCustomRoute(
            builder: (_) => ForgotPasswordScreen(),
            settings: settings,
          );
        case UnityMapScreen.routeName:
          return MyCustomRoute(
            builder: (_) => UnityMapScreen(
              distance: settings.arguments,
            ),
            settings: settings,
          );
        case CommunitySeeAllScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => CommunitySeeAllScreen(
              experienceId: dataArg['experId'],
            ),
            settings: settings,
          );
        case ChangePasswordScreen.routeName:
          return MyCustomRoute(
            builder: (_) => ChangePasswordScreen(),
            settings: settings,
          );
        case ProfilePage.routeName:
          return MyCustomRoute(
            builder: (_) => ProfilePage(),
            settings: settings,
          );
        case SettingsPage.routeName:
          return MyCustomRoute(
            builder: (_) => SettingsPage(),
            settings: settings,
          );
        case AssetDetailScreen.routeName:
          final Map data = settings.arguments;
          return MyCustomRoute(
            builder: (_) => AssetDetailScreen(
              placeModel: data.containsKey('data') ? data['data'] : null,
              id: data.containsKey('id') ? data['id'] : null,
            ),
            settings: settings,
          );
        case HelpPage.routeName:
          return MyCustomRoute(
            builder: (_) => HelpPage(),
            settings: settings,
          );
        case SaveItemPage.routeName:
          return MyCustomRoute(
            builder: (_) => SaveItemPage(),
            settings: settings,
          );
        case EventDetailScreen.routeName:
          final Map data = settings.arguments;
          return MyCustomRoute(
            builder: (_) => EventDetailScreen(
              eventInfo: data.containsKey('data') ? data['data'] : null,
              id: data.containsKey('id') ? data['id'] : null,
            ),
            settings: settings,
          );
        case CommunityPostPhotoPage.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => CommunityPostPhotoPage(
              pathImage: dataArg['path'],
              id: dataArg.containsKey('id') ? dataArg['id'] : null,
            ),
            settings: settings,
          );
        case CommunityWriteReviewPage.routeName:
          // ignore: close_sinks
          final baseBloc = sl<BaseBloc>();
          if (baseBloc.state.userInfo != null &&
              baseBloc.state.userInfo.isUser()) {
            final Map dataArg = settings.arguments;
            return MyCustomRoute(
              builder: (_) => CommunityWriteReviewPage(
                id: (dataArg?.containsKey('id') ?? false)
                    ? dataArg['id']
                    : null,
              ),
              settings: settings,
            );
          }
          return MyCustomRoute(
            builder: (_) => LoginPage(),
            settings: settings,
          );

        case LegalPolicyPage.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => LegalPolicyPage(
              title: dataArg['title'],
              html: dataArg['html'],
            ),
            settings: settings,
          );
        case CongratulationRegisterScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => CongratulationRegisterScreen(
              congratulationEnum:
                  dataArg.containsKey('type') ? dataArg['type'] : null,
            ),
            settings: settings,
          );
        case NotificationSettingScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => NotificationSettingScreen(
                dataArg?.containsKey('firstTime') ?? false
                    ? dataArg['firstTime']
                    : false),
            settings: settings,
          );
        case CommunityCongratulationScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => CommunityCongratulationScreen(
              title: dataArg['title'],
              description: dataArg['description'],
            ),
            settings: settings,
          );
        case ActivityDetailScreen.routeName:
          return MyCustomRoute(
            builder: (_) => ActivityDetailScreen(
              item: settings.arguments,
            ),
            settings: settings,
          );
        case AssetSeeAllGridScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => AssetSeeAllGridScreen(
              viewAssetType: dataArg['type'],
              filterAdv: dataArg['filterAdv'],
              experienceId: dataArg['experId'],
              facilitesId: dataArg['facilitesId'],
            ),
            settings: settings,
          );
        case AssetSeeAllListScreen.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => AssetSeeAllListScreen(
              viewAssetType: dataArg['type'],
              filterAdv: dataArg['filterAdv'],
              experienceId: dataArg['experId'],
              facilitesId: dataArg['facilitesId'],
            ),
            settings: settings,
          );
        case PersonalizationScreen.routeName:
          return MyCustomRoute(
            builder: (_) => PersonalizationScreen(),
          );
        case RegisterPage.routeName:
          final Map dataArg = settings.arguments;
          return MyCustomRoute(
            builder: (_) => RegisterPage(
              registerEnum: dataArg['type'],
              socialLoginData: dataArg['data'],
            ),
          );
        case StartedScreen.routeName:
          return MyCustomRoute(
            builder: (_) => StartedScreen(),
            settings: settings,
          );
        case LoginPage.routeName:
          return MyCustomRoute(
            builder: (_) => LoginPage(),
            settings: settings,
          );
        case VerifyCodeScreen.routeName:
          var comeFrom = '';
          final Map dataArg = settings.arguments;
          if (dataArg != null && dataArg.containsKey(RouteArgument.comeFrom)) {
            comeFrom = dataArg[RouteArgument.comeFrom];
          }
          return MyCustomRoute(
            builder: (_) => VerifyCodeScreen(
              comeFrom: comeFrom,
            ),
            settings: settings,
          );
        case MainScreen.routeName:
          return MyCustomRoute(
            builder: (_) => MainScreen(),
            settings: settings,
          );
        case NotificationHistoryScreen.routeName:
          return MyCustomRoute(
            builder: (_) => NotificationHistoryScreen(),
            settings: settings,
          );
        case DeactivateAccountPage.routeName:
          return MyCustomRoute(
            builder: (_) => DeactivateAccountPage(),
            settings: settings,
          );
        case ReportPage.routeName:
          return MyCustomRoute(
            builder: (_) => ReportPage(),
            settings: settings,
          );
        case MyCommunityPage.routeName:
          return MyCustomRoute(
            builder: (_) => MyCommunityPage(),
            settings: settings,
          );
        default:
          return MyCustomRoute(
            builder: (_) => SplashScreen(),
            settings: settings,
          );
      }
    };

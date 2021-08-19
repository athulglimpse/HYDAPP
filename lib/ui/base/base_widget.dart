import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvista/ui/community/community_detail/community_detail_page.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/dialog_loading.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/language.dart';
import '../../data/repository/user_repository.dart';
import '../../data/source/api_end_point.dart';
import '../../utils/navigate_util.dart';
import '../../utils/uni_link_wrapper.dart';
import '../assets/asset_detail/asset_detail_page.dart';
import '../event/detail/event_detail_page.dart';
import '../getstarted/get_started_page.dart';
import '../main/main_page.dart';
import '../notification_history/notification_history_page.dart';
import 'bloc/base_bloc.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BaseState();
  }
}

class BaseState<T extends BaseWidget> extends State<T> {
  DialogLoading dialogLoad;
  bool canTouchToHideKeyboard = false;
  bool canClickOnBackPress = false;
  bool isFirstTimeInit = true;
  bool canTriggerOnBack = false;
  final _baseBloc = sl<BaseBloc>();
  StreamSubscription streamSubscriptionBase;
  StreamSubscription streamNotificationBase;

  void needHideKeyboard() {
    canTouchToHideKeyboard = true;
  }

  void changeLang(Language lang) {

    updateLangEndPoint(
        Locale(lang.code.toLowerCase(), lang.countryCode.toUpperCase()),
        canInitLocalDate: true);
    context.locale =
        Locale(lang.code.toLowerCase(), lang.countryCode.toUpperCase());
  }

  void lockPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }

  void canClickBackPress() {
    canClickOnBackPress = true;
  }

  ///this function work for Android
  Future<bool> onCustomBackPress() {
    return Future(() => canClickOnBackPress);
  }

  Widget makeParent(Widget widget) {
    return widget;
  }

  @override
  void initState() {
    super.initState();

    streamSubscriptionBase = _baseBloc.listen((state) {
      if (state is AppLink) {
        UniLinkWrapper.handleDirectLink(
          uri: state.uri,
          userInfo: state.userInfo,
          context: context,
        );
        _baseBloc.add(Init());
      } else if (state is LogoutState) {
        NavigateUtil.pop(context,
            routeName: StartedScreen.routeName, release: true);
      }
    });

    lockPortrait();

    ///Listen when user click on Notification
    streamNotificationBase =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      checkDirectNotification(context, message);
    });
  }

  static bool checkDirectNotification(
      BuildContext context, RemoteMessage message,
      {String dataId, String dataType}) {
    final String id = (message?.data?.containsKey('id') ?? false)
        ? message.data['id']
        : dataId;
    final String type = (message?.data?.containsKey('type') ?? false)
        ? message.data['type']
        : dataType;

    final userRepository = sl<UserRepository>();
    final userInfo = userRepository.getCurrentUser();
    if (userInfo != null &&
        userInfo.isUser() &&
        (id?.isNotEmpty ?? false) &&
        (type?.isNotEmpty ?? false)) {
      switch (type) {
        case PARAM_MY_POST:
        case PARAM_COMMUNITY_POST:
        case PARAM_COMMENT:
          NavigateUtil.openPage(context, CommunityDetailScreen.routeName,
                  argument: {'id': id})
              .then((value) => NavigateUtil.openPage(
                  context, MainScreen.routeName,
                  release: true));
          break;
        case PARAM_AMENITY:
          NavigateUtil.openPage(context, AssetDetailScreen.routeName,
                  argument: {'id': id})
              .then((value) => NavigateUtil.openPage(
                  context, MainScreen.routeName,
                  release: true));
          return true;
        case PARAM_EVENT_DETAILS:
          NavigateUtil.openPage(context, EventDetailScreen.routeName,
                  argument: {'id': id})
              .then((value) => NavigateUtil.openPage(
                  context, MainScreen.routeName,
                  release: true));
          return true;
        default:
          break;
      }
      NavigateUtil.openPage(context, NotificationHistoryScreen.routeName).then(
          (value) => NavigateUtil.openPage(context, MainScreen.routeName,
              release: true));
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscriptionBase?.cancel();
    streamNotificationBase?.cancel();
  }

  void hideKeyboard() {}

  void hideLoading() {
    if (dialogLoad != null) {
      dialogLoad.onDissmis(context);
      dialogLoad = null;
    }
  }

  void showLoading() {
    dialogLoad ??= DialogLoading();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => dialogLoad);
  }

  void notifyError(String error) {
    hideLoading();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: MyTextView(
            text: 'Error',
            textStyle: textNormal.copyWith(color: Colors.black),
          ),
          content: MyTextView(text: error),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: MyTextView(
                text: 'Close',
                textStyle: textNormal.copyWith(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}

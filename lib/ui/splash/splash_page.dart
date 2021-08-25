import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marvista/data/source/api_end_point.dart';

import '../../common/di/injection/injector.dart';
import '../../data/repository/user_repository.dart';
import '../../utils/app_const.dart';
import '../../utils/my_custom_route.dart';
import '../../utils/navigate_util.dart';
import '../../utils/uni_link_wrapper.dart';
import '../base/base_widget.dart';
import '../getstarted/get_started_page.dart';
import '../main/main_page.dart';
import '../personalization/personalization_page.dart';
import '../verifycode/verify_code_page.dart';
import 'bloc/splash_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashScreen extends BaseWidget {
  static const routeName = 'SplashScreen';

  SplashScreen();

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends BaseState<SplashScreen>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  final SplashBloc _splashBloc = sl<SplashBloc>();
  AnimationController _iconAnimationController;
  CurvedAnimation _iconAnimation;

  @override
  void initState() {
    super.initState();
    //Call this method first when LoginScreen init
    initBasicInfo();
    _iconAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _iconAnimation =
        CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeIn);
    _iconAnimation.addListener(() => setState(() {}));

    _iconAnimationController.forward();
  }

  void initBasicInfo() {


    _splashBloc.listen((state) {
      if (state is Logged && state.userInfo != null) {
        if (!state.userInfo.isUser()) {
          NavigateUtil.replacePage(context, StartedScreen.routeName,
              argument: state.userInfo);
        } else if (!state.userInfo.isActivated()) {
          NavigateUtil.replacePage(context, VerifyCodeScreen.routeName,
              argument: {RouteArgument.comeFrom: SplashScreen.routeName});
        } else if (state.userInfo.hasFillPersonalization == 0) {
          if (isMVP) {
            NavigateUtil.replacePage(context, MainScreen.routeName);
          } else {
            NavigateUtil.replacePage(context, PersonalizationScreen.routeName);
          }
        } else {
          //User need fill personalization dataqq
          NavigateUtil.replacePage(context, MainScreen.routeName,
              argument: state.userInfo);
        }
      } else if (state is SignedOut) {
        NavigateUtil.replacePage(context, StartedScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image(
        image: const AssetImage('assets/logo.png'),
        width: _iconAnimation.value * 100,
        height: _iconAnimation.value * 100,
      )),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _splashBloc.close();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    updateLangEndPoint(context.locale, canInitLocalDate: true);
    checkInitWidget(context);
  }

  Future<void> checkInitWidget(BuildContext context) async {
    final uniLinkWrapper = sl<UniLinkWrapper>();
    final userRepository = sl<UserRepository>();
    final userInfo = userRepository.getCurrentUser();
    // Get any messages which caused the application to open from
    // a terminated state.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "event|amenity|post",
    // navigate to a detail page
    if (BaseState.checkDirectNotification(context, initialMessage)) {
      return;
    }

    if (UniLinkWrapper.handleDirectLink(
      uri: uniLinkWrapper.getUri(),
      userInfo: userRepository.getCurrentUser(),
      context: context,
    )) {
    } else if (userInfo != null && userInfo.isUser()) {
      // await Future.delayed(const Duration(milliseconds: 2));
      _splashBloc.add(FetchOnlyConfig());
      if (!userInfo.isActivated()) {
        await NavigateUtil.replacePage(context, VerifyCodeScreen.routeName,
            argument: {RouteArgument.comeFrom: SplashScreen.routeName});
      } else if (userInfo.hasFillPersonalization == 0) {
        if (isMVP) {
          await NavigateUtil.openPage(context, MainScreen.routeName);
        } else {
          await NavigateUtil.openPage(context, PersonalizationScreen.routeName);
        }
      } else {
        //User need fill personalization dataqq
        await NavigateUtil.openPage(context, MainScreen.routeName,
            argument: userInfo);
      }
    } else {
      _splashBloc.add(FetchConfig());
    }
  }
}

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'common/di/injection/injector.dart';
import 'common/theme/theme.dart';
import 'data/repository/user_repository.dart';
import 'data/source/api_end_point.dart';
import 'ui/base/base_widget.dart';
import 'ui/splash/splash_page.dart';
import 'utils/firebase_wrapper.dart';
import 'utils/my_custom_route.dart';

class Application extends StatelessWidget {
  // This widget is the root of your application.
  static BuildContext currentContext;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    updateLangEndPoint(context.locale);

    const android = AndroidInitializationSettings('ic_notify');
    const IOS = IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    const settings = InitializationSettings(android: android, iOS: IOS);

    //Config onClick notification for Android
    flutterLocalNotificationsPlugin.initialize(settings,
        // ignore: missing_return
        onSelectNotification: (data) {
      if (data?.isNotEmpty ?? false) {
        try {
          final dataConvert = json.decode(json.decode(data)['data']);
          final id = dataConvert['id'];
          final type = dataConvert['type'];
          BaseState.checkDirectNotification(Application.currentContext, null,
              dataId: id.toString(), dataType: type.toString());
        } catch (ex) {
          print(ex.toString());
        }
      }
    });

    //Config onClick notification for iOS
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data?.isNotEmpty ?? false) {
        try {
          final dataConvert =
              json.decode(json.decode(message.data['data'])['data']);
          final id = dataConvert['id'];
          final type = dataConvert['type'];
          BaseState.checkDirectNotification(Application.currentContext, null,
              dataId: id.toString(), dataType: type.toString());
        } catch (ex) {
          print(ex.toString());
        }
      }
    });
    //Config  notification for Android
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final android = message.notification.android;
      final notification = message.notification;
      final title = notification.title;
      final body = notification.body;
      final userInfo = sl<UserRepository>().getCurrentUser();
      if (notification != null &&
          android != null &&
          userInfo != null &&
          userInfo.isUser() &&
          title.isNotEmpty &&
          body.isNotEmpty) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'ic_notify',
                // other properties...
              ),
            ),
            payload: json.encode(message.data));
      }
    });
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hudayriyat Island',
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasyLocalization.of(context).delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: myRoute,
          supportedLocales: EasyLocalization.of(context).supportedLocales,
          locale: EasyLocalization.of(context).locale,
          theme: defaultTheme(),
          home: SplashScreen(),
        ));
  }
}

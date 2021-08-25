import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'common/di/injection/injector.dart';
import 'ui/base/bloc/base_bloc.dart';
import 'utils/firebase_wrapper.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print('Handling a background message: ${message.messageId}');
}

 void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    /* set Status bar color in Android devices. */
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    /* set Status bar icons color in Android devices.*/
    statusBarBrightness:
        Brightness.dark, /* set Status bar icon color in iOS. */
  ));
  
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;
  getIt.registerSingleton<FirebaseWrapper>(FirebaseWrapper());

  await Injection.inject();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Container(
    color: Colors.white,
    child: EasyLocalization(
      // preloaderColor: Colors.white,
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AE')],
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      saveLocale: true,
      path: 'res/langs',
      child: BlocProvider(
        create: (_) => sl<BaseBloc>(),
        child: Application(),
      ),
    ),
  ));
}

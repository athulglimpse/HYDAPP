import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../data/model/social_login_data.dart';
import '../data/source/failure.dart';
import 'app_const.dart';
import 'ui_util.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseWrapper {
  FirebaseAuth auth;
  RemoteConfig remoteConfig;
  FirebaseMessaging messaging;
  NotificationSettings settings;
  String tokenLocal;

  Future<void> init() async {
    await initializeFlutterFire();
  }

// Define an async function to initialize FlutterFire
  Future<void> initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      messaging = FirebaseMessaging.instance;
      await initFirebaseMessaging();
      auth = FirebaseAuth.instance;
      remoteConfig = await setupRemoteConfig();
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    } catch (e) {
      UIUtil.showToast(e);
    }
  }

  String _createNonce(int length) {
    final random = Random();
    final charCodes = List<int>.generate(length, (_) {
      int codeUnit;

      switch (random.nextInt(3)) {
        case 0:
          codeUnit = random.nextInt(10) + 48;
          break;
        case 1:
          codeUnit = random.nextInt(26) + 65;
          break;
        case 2:
          codeUnit = random.nextInt(26) + 97;
          break;
      }

      return codeUnit;
    });

    return String.fromCharCodes(charCodes);
  }

  Future<Either<ExceptionDataFailure, SocialLoginData>>
      handleGoogleSignIn() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final user = (await auth.signInWithCredential(credential)).user;
      final socialLoginData = SocialLoginData.copyWithGoogleData(
          id: user.uid, email: user.email, displayName: user.displayName);
      return Right(socialLoginData);
    } on FirebaseAuthException catch (error) {
      return handleErrors(error);
    }
  }

  Future<Either<ExceptionDataFailure, SocialLoginData>>
      handleFacebookSignIn() async {
    try {
      // Trigger the sign-in flow
      final result = await FacebookAuth.instance.login();
      // Create a credential from the access token
      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken.token);
      // Once signed in, return the UserCredential
      final userCredential =
          await auth.signInWithCredential(facebookAuthCredential);
      final profile = userCredential.additionalUserInfo.profile;
      profile['id'] = userCredential.user.uid;
      final socialLoginData = SocialLoginData.copyWithFacebookData(profile);
      return Right(socialLoginData);
    } on FirebaseAuthException catch (error) {
      return handleErrors(error);
    }
  }

  Future<Either<ExceptionDataFailure, SocialLoginData>>
      handleAppleSignIn() async {
    try {
      final oauthCredResult = await _createAppleOAuthCred();
      return await oauthCredResult.fold(
        (failure) => Left(failure),
        (oauthCred) async {
          final user = (await auth.signInWithCredential(oauthCred)).user;
          final socialLoginData = SocialLoginData.copyWithGoogleData(
              id: user.uid, email: user.email, displayName: user.displayName);
          return Right(socialLoginData);
        },
      );
    } on FirebaseAuthException catch (error) {
      return handleErrors(error);
    }
  }

  Future<Either<ExceptionDataFailure, OAuthCredential>>
      _createAppleOAuthCred() async {
    try {
      final nonce = _createNonce(32);
      final nativeAppleCred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256.convert(utf8.encode(nonce)).toString(),
      );
      return Right(OAuthCredential(
        providerId: 'apple.com',
        accessToken: nativeAppleCred.identityToken,
        // propagate Apple ID token to BOTH accessToken and idToken parameters
        idToken: nativeAppleCred.identityToken,
        rawNonce: nonce, signInMethod: 'oauth',
      ));
    } catch (error) {
      return Left(ExceptionDataFailure(errorMessage: error.toString()));
    }
  }

  Future<Either<ExceptionDataFailure, SocialLoginData>> handleErrors(
      FirebaseAuthException e) async {
    try {
      if (e.code == 'account-exists-with-different-credential') {
        // The account already exists with a different credential
        final email = e.email;
        // Fetch a list of what sign-in methods exist for the conflicting user
        final userSignInMethods = await auth.fetchSignInMethodsForEmail(email);
        // Since other providers are now external,
        // you must now sign the user in with another
        // auth provider, such as Facebook.
        if (userSignInMethods.first == 'google.com') {
          // Trigger the authentication flow
          final googleUser = await GoogleSignIn().signIn();
          // Obtain the auth details from the request
          final googleAuth = await googleUser.authentication;
          // Create a new credential
          final GoogleAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final userCredential = await auth.signInWithCredential(credential);

          return Right(SocialLoginData.copyWith(
              email: userCredential.user.email,
              displayName: userCredential.user.displayName,
              id: userCredential.user.uid));
        }
        if (userSignInMethods.first == 'facebook.com') {
          // Create a new Facebook credential
          final result = await FacebookAuth.instance.login();
          final accessToken = result.accessToken.token;
          final facebookAuthCredential =
              FacebookAuthProvider.credential(accessToken);
          // Sign the user in with the credential
          final userCredential =
              await auth.signInWithCredential(facebookAuthCredential);
          // Link the pending credential with the existing account
          return Right(SocialLoginData.copyWith(
              email: userCredential.user.email,
              displayName: userCredential.user.displayName,
              id: userCredential.user.uid));
        }
        if (userSignInMethods.first == 'apple.com') {
          final oauthCredResult = await _createAppleOAuthCred();
          return await oauthCredResult.fold(
            (failure) => Left(failure),
            (oauthCred) async {
              final userCredential = await auth.signInWithCredential(oauthCred);
              final socialLoginData = SocialLoginData.copyWithGoogleData(
                  id: userCredential.user.uid,
                  email: userCredential.user.email,
                  displayName: userCredential.user.displayName);
              return Right(socialLoginData);
            },
          );
        }
      }
    } catch (e) {
      return Left(ExceptionDataFailure(errorMessage: e.toString()));
    }
    return null;
  }

  Future<void> signOut() async {
    if ((await FacebookAuth.instance.accessToken) != null) {
      await FacebookAuth.instance.logOut();
    }
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
    await auth.signOut();
  }

  RemoteConfig getRemoteConfig() {
    return remoteConfig;
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final defaults = <String, dynamic>{'isMapEnable': false, 'isMVP': true};
    final remoteConfig = await RemoteConfig.instance;

    await remoteConfig.setDefaults(defaults);
    // Enable developer mode to relax fetch throttling
    await remoteConfig.setConfigSettings(RemoteConfigSettings());
    await remoteConfig.fetch(/*expiration: const Duration(seconds: 30)*/);
    await remoteConfig.activate();
    // isMVP = remoteConfig.getBool('isMVP');
    isMapEnable = true; // remoteConfig.getBool('isMapEnable');

    return remoteConfig;
  }

  Future<void> initFirebaseMessaging() async {
    //
    // ///https://firebase.flutter.dev/docs/messaging/usage
    await requestNotificationPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    //get Token
    await messaging.getToken().then((token) {
      tokenLocal = token;
      print(tokenLocal);

      ///Subscribe topic
      messaging.subscribeToTopic(DEFAULT_TOPICS_MARVISTA_ANNOUNCEMENTS);
      messaging.subscribeToTopic(DEFAULT_TOPICS_EVENT);
      messaging.subscribeToTopic(DEFAULT_TOPICS_COMMUNITY_POSTS);
      messaging.subscribeToTopic(DEFAULT_TOPICS_APPROVED_POSTS);
    });
    messaging.onTokenRefresh.listen((token) => {tokenLocal = token});
  }

  Future<void> subscribeToTopic(String topic) async {
    print('subscribeToTopic ' + topic);
    await messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    print('unsubscribeFromTopic ' + topic);
    await messaging.unsubscribeFromTopic(topic).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> requestNotificationPermission() async {
    if (settings == null ||
        settings?.authorizationStatus != AuthorizationStatus.authorized) {
      settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings?.authorizationStatus != null) {
        switch (settings.authorizationStatus) {
          case AuthorizationStatus.authorized:

            ///The user granted permission.
            break;
          case AuthorizationStatus.denied:

            ///The user denied permission.
            break;
          case AuthorizationStatus.notDetermined:

            ///The user has not yet chosen whether to grant permission.
            break;
          case AuthorizationStatus.provisional:

            ///The user granted provisional permission (see Provisional Permission).
            break;
        }
      }
    }
  }
}

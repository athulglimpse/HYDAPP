import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class FacebookWrapper {
  FacebookLoginResult _facebookLoginResult;
  FacebookLoginResult get facebookLoginResult => _facebookLoginResult;

  bool hasLogin() {
    return _facebookLoginResult != null &&
        _facebookLoginResult.status == FacebookLoginStatus.loggedIn;
  }

  Future<Map> handleFacebookSignIn() async {
    try {
      final facebookLogin = FacebookLogin();
      _facebookLoginResult = await facebookLogin.logIn(['email']);
      switch (_facebookLoginResult.status) {
        case FacebookLoginStatus.loggedIn:
          final data = await fetchUserProfile(
              token: _facebookLoginResult.accessToken.token);
          return data;
          break;
        case FacebookLoginStatus.cancelledByUser:
          return {'cancel': true};
          break;
        case FacebookLoginStatus.error:
          return {'error': _facebookLoginResult.errorMessage};
          break;
      }
    } catch (error) {
      print('error ' + error);
    }
    return null;
  }

  Future<Map> fetchUserProfile({String token}) async {
    final dio = Dio();
    final graphResponse = await dio.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = json.decode(graphResponse.data);
    return profile;
  }
}

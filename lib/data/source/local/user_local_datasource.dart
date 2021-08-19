import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../../utils/utils.dart';
import '../../model/user_info.dart';
import '../success.dart';
import 'prefs/app_preferences.dart';

abstract class UserLocalDataSource {
  UserInfo getCurrentUser();
  String getAccessToken();

  Future<Success> logout();

  void saveCurrentUser(UserInfo userInfo);
  void saveAccessToken(String accessToken);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppPreferences appPreferences;

  UserLocalDataSourceImpl({@required this.appPreferences});

  @override
  UserInfo getCurrentUser() {
    try {
      final jsonString = appPreferences.getUserInfo();
      if (jsonString != null) {
        final decJson = Utils.decData(jsonString);
        return UserInfo.fromJson(json.decode(decJson));
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(UserInfo userInfo) async {
    final encodeJson = json.encode(userInfo.toJson());
    final encryptJson = Utils.encData(encodeJson);
    return appPreferences.saveUserInfo(encryptJson);
  }

  @override
  String getAccessToken() {
    try {
      final jsonString = appPreferences.getAccessToken();
      if (jsonString != null) {
        return Utils.decData(jsonString);
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void saveAccessToken(String accessToken) {
    final encryptJson = Utils.encData(accessToken);
    return appPreferences.saveAccessToken(encryptJson);
  }

  @override
  Future<Success> logout() async {
    await appPreferences.clearUserData();
    return Success();
  }
}

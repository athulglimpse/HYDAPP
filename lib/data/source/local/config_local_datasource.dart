import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/app_config.dart';
import 'prefs/app_preferences.dart';

abstract class ConfigLocalDataSource {
  AppConfig getAppConfig();

  void saveAppConfig(AppConfig userInfo);
}

class ConfigLocalDataSourceImpl implements ConfigLocalDataSource {
  final AppPreferences appPreferences;

  ConfigLocalDataSourceImpl({@required this.appPreferences});

  @override
  AppConfig getAppConfig() {
    try {
      final jsonString = appPreferences.getAppConfig();
      if (jsonString != null) {
        return AppConfig.fromJson(json.decode(jsonString));
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
  void saveAppConfig(AppConfig appConfig) {
    final encodeJson = json.encode(appConfig.toJson());
    return appPreferences.saveAppConfig(encodeJson);
  }
}

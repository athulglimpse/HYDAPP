import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/static_content.dart';
import 'prefs/app_preferences.dart';

abstract class StaticContentLocalDataSource {
  StaticContent getStaticContent();

  void saveStaticContent(StaticContent staticContent);
}

class StaticContentLocalDataSourceImpl implements StaticContentLocalDataSource {
  final AppPreferences appPreferences;

  StaticContentLocalDataSourceImpl({@required this.appPreferences});

  @override
  StaticContent getStaticContent() {
    final jsonString = appPreferences.getStaticContent();
    if (jsonString != null) {
      return StaticContent.fromJson(json.decode(jsonString));
    } else {
      return null;
    }
  }

  @override
  void saveStaticContent(StaticContent staticContent) {
    return appPreferences
        .saveStaticContent(json.encode(staticContent.toJson()));
  }
}

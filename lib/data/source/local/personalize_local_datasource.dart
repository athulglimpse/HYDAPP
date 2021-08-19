import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/personalization_item.dart';
import 'prefs/app_preferences.dart';

abstract class PersonalizeLocalDataSource {
  List<PersonalizationItem> getListPersonalizeItems();

  void saveListPersonalizeItems(List<PersonalizationItem> list);
}

class PersonalizeLocalDataSourceImpl implements PersonalizeLocalDataSource {
  final AppPreferences appPreferences;

  PersonalizeLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<PersonalizationItem> getListPersonalizeItems() {
    final jsonString = appPreferences.getPersonalizationItems();
    if (jsonString != null) {
      final List<dynamic> strMap = json.decode(jsonString);
      final interestInfs =
          strMap.map((v) => PersonalizationItem.fromJson(v)).toList();
      return interestInfs;
    } else {
      return null;
    }
  }

  @override
  void saveListPersonalizeItems(List<PersonalizationItem> list) {
    final str = list.map((v) => v.toJson()).toList();
    return appPreferences.savePersonalizationItems(json.encode(str));
  }
}

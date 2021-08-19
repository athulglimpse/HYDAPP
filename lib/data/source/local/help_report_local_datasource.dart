import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/help_report_model.dart';

import '../../model/app_config.dart';
import 'prefs/app_preferences.dart';

abstract class HelpReportLocalDataSource {
  List<HelpReportModel> helpItems();

  void saveHelpItems(List<HelpReportModel> helpItems);

  List<HelpReportModel> reportItems();

  void saveReportItems(List<HelpReportModel> reportItems);
}

class HelpReportLocalDataSourceImpl implements HelpReportLocalDataSource {
  final AppPreferences appPreferences;

  HelpReportLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<HelpReportModel> helpItems() {
    try {
      final jsonString = appPreferences.getHelpItems();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final data = strMap.map((v) => HelpReportModel.fromJson(v)).toList();
        return data;
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
  List<HelpReportModel> reportItems() {
    try {
      final jsonString = appPreferences.getReportItems();
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final data = strMap.map((v) => HelpReportModel.fromJson(v)).toList();
        return data;
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
  void saveHelpItems(List<HelpReportModel> helpItems) {
    final str = helpItems.map((v) => v.toJson()).toList();
    return appPreferences.saveHelpItems(json.encode(str));
  }

  @override
  void saveReportItems(List<HelpReportModel> reportItems) {
    final str = reportItems.map((v) => v.toJson()).toList();
    return appPreferences.saveReportItems(json.encode(str));
  }
}

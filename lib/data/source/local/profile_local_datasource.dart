import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/user_community_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/save_item_model.dart';

abstract class ProfileLocalDataSource {
  ///Local Data
  List<SaveItemModel> getSaveItem(String id);

  Future<void> saveSaveItem(String id, List<SaveItemModel> assets);

  List<UserCommunityModel> getMyCommunity(String id);

  Future<void> saveMyCommunity(String id, List<UserCommunityModel> assets);
}

const CACHED_SAVE_ITEM = 'CACHED_SAVE_ITEM';
const CACHED_MY_COMMUNITY = 'CACHED_MY_COMMUNITY';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> saveSaveItem(String id, List<SaveItemModel> saveItem) {
    final str = saveItem.map((v) => v.toJson()).toList();
    return sharedPreferences.setString(
      // ignore: prefer_interpolation_to_compose_strings
      CACHED_SAVE_ITEM + '_' + id,
      json.encode(str),
    );
  }

  @override
  List<SaveItemModel> getSaveItem(String id) {
    try {
      final jsonString =
          // ignore: prefer_interpolation_to_compose_strings
          sharedPreferences.getString(CACHED_SAVE_ITEM + '_' + id);
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final List<dynamic> listSaveItem =
            strMap.map((v) => SaveItemModel.fromJson(v)).toList();
        return listSaveItem;
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
  List<UserCommunityModel> getMyCommunity(String id) {
    try {
      final jsonString =
      // ignore: prefer_interpolation_to_compose_strings
      sharedPreferences.getString(CACHED_MY_COMMUNITY + '_' + id);
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final List<dynamic> listSaveItem =
        strMap.map((v) => UserCommunityModel.fromJson(v)).toList();
        return listSaveItem;
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
  Future<void> saveMyCommunity(String id, List<UserCommunityModel> model) {
    final str = model.map((v) => v.toJson()).toList();
    return sharedPreferences.setString(
      // ignore: prefer_interpolation_to_compose_strings
      CACHED_MY_COMMUNITY + '_' + id,
      json.encode(str),
    );
  }
}

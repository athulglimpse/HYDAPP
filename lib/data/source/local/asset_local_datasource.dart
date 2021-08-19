import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:marvista/data/model/asset_detail.dart';

import '../../../ui/assets/asset_see_all/asset_see_all_grid_page.dart';
import '../../model/places_model.dart';
import 'prefs/app_preferences.dart';

abstract class AssetLocalDataSource {
  ///Local Data

  AssetDetail getAssetDetail(String it);

  void saveAssetDetail(AssetDetail detail, String id);

  ///
  List<PlaceModel> getAssets(ViewAssetType viewAssetType);

  void saveAssets(List<PlaceModel> assets, ViewAssetType viewAssetType);
}

class AssetLocalDataSourceImpl implements AssetLocalDataSource {
  final AppPreferences appPreferences;

  AssetLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<PlaceModel> getAssets(ViewAssetType viewAssetType) {
    try {
      final jsonString = appPreferences.getAsset(viewAssetType);
      if (jsonString != null) {
        final List<dynamic> strMap = json.decode(jsonString);
        final assets = strMap.map((v) => PlaceModel.fromJson(v)).toList();
        return assets;
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
  void saveAssets(List<PlaceModel> assets, ViewAssetType viewAssetType) {
    final str = assets.map((v) => v.toJson()).toList();
    return appPreferences.saveAsset(json.encode(str), viewAssetType);
  }

  @override
  AssetDetail getAssetDetail(String id) {
    try {
      final jsonString = appPreferences.getAssetDetail(id);
      if (jsonString != null) {
        return AssetDetail.fromJson(json.decode(jsonString));
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
  void saveAssetDetail(AssetDetail detail, String id) {
    final str = detail.toJson();
    return appPreferences.saveAssetDetail(json.encode(str), id);
  }
}

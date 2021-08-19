import 'dart:convert';

import 'package:marvista/data/model/area_item.dart';
import 'package:marvista/ui/filter/util/filter_util.dart';
import 'package:marvista/utils/log_utils.dart';

import '../../../common/localization/lang.dart';
import '../../../ui/assets/asset_see_all/asset_see_all_grid_page.dart';
import '../../model/asset_detail.dart';
import '../../model/places_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class AssetRemoteDataSource {
  ///GET API
  Future<AssetDetail> fetchAmenityDetail(String id);

  Future<List<PlaceModel>> fetchAmenitiesAlsoLike(String id);

  Future<List<PlaceModel>> fetchAmenities(
      {ViewAssetType viewAssetType,
      dynamic filter,
      String experienceId,
      Map<int, Map> filterAdv,
      String category});

  Future<List<AssetDetail>> fetchSearchAsset(String content);
}

class AssetRemoteDataSourceImpl extends RemoteBaseImpl
    implements AssetRemoteDataSource {
  AssetRemoteDataSourceImpl();

  @override
  Future<AssetDetail> fetchAmenityDetail(String id) async {
    setPrivateToken();
    final response = await dio.get(endPointGetAssetDetail.format([id]),
        queryParameters: {
          't': DateTime.now().toIso8601String()
        }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<AssetDetail>(response, (responseData) {
      return AssetDetail.fromJson(responseData.data);
    });
  }

  @override
  Future<List<PlaceModel>> fetchAmenities(
      {ViewAssetType viewAssetType,
      dynamic filter,
      Map<int, Map> filterAdv,
      String experienceId,
      String category}) async {
    setPrivateToken();
    var url = endPointGetAmenities;
    var type = '';
    switch (viewAssetType) {
      case ViewAssetType.TRENDING_THIS_WEEK:
        url = endPointGetAmenities;
        type = 'trending';
        break;
      case ViewAssetType.MIGHT_LIKE:
        url = endPointGetAmenities;
        type = 'might_like';
        break;
      case ViewAssetType.TOP_RATE:
        url = endPointGetAmenities;
        type = 'top_rated';
        break;
      case ViewAssetType.RESTAURANTS:
        url = endPointGetAmenities;
        type = 'restaurants';
        break;
      case ViewAssetType.FACILITIES:
        url = endPointGetAmenities;
        type = 'facilities';
        break;
      case ViewAssetType.ACTIVITIES:
        url = endPointGetAmenities;
        type = 'activities';
        break;
      case ViewAssetType.FOOD_TRUCKS:
        url = endPointGetAmenities;
        type = 'food trucks';
        break;
    }
    final filterAdvData = <Map>[];
    try {
      if (filterAdv?.isNotEmpty ?? false) {
        filterAdv.entries.forEach((e) {
          if (e.value['type'] == 'selection' && e.value['value'] != null) {
            final filterItem = e.value['value'];
            filterAdvData.add({
              'fid': e.value['fid'],
              'type': e.value['type'],
              'data': [filterItem.id],
            });
          } else if (e.value['type'] == 'multi_selection') {
            final Map<int, FilterItem> filterItem = e.value['value'];
            final listId = <int>[];
            filterItem.forEach((key, value) {
              listId.add(value.id);
            });
            if (listId.isNotEmpty) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': listId,
              });
            }
          } else if (e.value['type'] == 'icon_single_selection') {
            final filterItem = e.value['value'];
            if (filterItem != null) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': [filterItem.id],
              });
            }
          } else if (e.value['type'] == 'icon_multi_selection') {
            final Map<int, FilterItem> filterItem = e.value['value'];
            final listId = <int>[];
            filterItem.forEach((key, value) {
              listId.add(value.id);
            });
            if (listId.isNotEmpty) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'data': listId,
              });
            }
          } else if (e.value['type'] == 'date') {
            final String startDate = e.value[FILTER_KEY_START_DATE];
            final String endDate = e.value[FILTER_KEY_END_DATE];
            if ((startDate != null && startDate.isNotEmpty) ||
                (endDate != null && endDate.isNotEmpty)) {
              filterAdvData.add({
                'fid': e.value['fid'],
                'type': e.value['type'],
                'by_date': {'startdate': startDate, 'enddate': endDate},
              });
            }
          }
        });
      }

      print(json.encode(filterAdvData));
    } catch (e) {
      LogUtils.d(e);
    }

    final response = await dio
        .get(url,
            queryParameters: Map.from({
              PARAM_TYPE: type,
              PARAM_CATEGORY: category,
              PARAM_FILTER_FACILITY: filter,
              'filter':
                  filterAdvData.isNotEmpty ? json.encode(filterAdvData) : '',
              PARAM_EXPERIENCE_ID: experienceId,
            }))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<PlaceModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => PlaceModel.fromJson(v)).toList();
    });
  }

  @override
  Future<List<PlaceModel>> fetchAmenitiesAlsoLike(String id) async {
    setPrivateToken();
    final response =
        await dio.get(endPointAmenityAlsoLike.format([id])).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<PlaceModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => PlaceModel.fromJson(v)).toList();
    });
  }

  @override
  Future<List<AssetDetail>> fetchSearchAsset(
    String content,
  ) async {
    setPrivateToken();
    final response =
        await dio.get(endPointSearchGroupByAsset, queryParameters: {
      'content': (content == null || content.isEmpty) ? '[]' : content,
      't': DateTime.now().toIso8601String(),
      'type': 'amenities_details',
      'page': 0,
      'sort[nid]': 'desc'
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<AssetDetail>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => AssetDetail.fromJson(v)).toList();
    });
  }
}

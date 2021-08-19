import 'package:marvista/ui/filter/util/filter_util.dart';

import '../../../utils/data_form_util.dart';
import '../../../utils/log_utils.dart';
import '../../../utils/weather_service.dart';
import '../../model/activity_model.dart';
import '../../model/area_item.dart';
import '../../model/community_model.dart';
import '../../model/weather_info.dart';
import '../../repository/home_repository.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class HomeRemoteDataSource {
  /// GET API
  Future<List<AreaItem>> fetchListExperiences();

  Future<WeatherInfo> fetchWeatherInfo({String lat, String lon});

  Future<List<ActivityModel>> fetchListWeekendActivities(
      {int pageIndex, String experienceId, dynamic filterData});

  Future<CommunityModel> fetchListCommunity(
      {int pageIndex,
      String experienceId,
      Map<int, Map> filterAdv,
      String amenityId,
      String cateId,
      dynamic filterData});

  ///POST API
  Future<Success> addFavorite(
      {String id, bool isFavorite, FavoriteType favoriteType});

  Future<Success> filterAreasHome(List<String> filter);

  Future<Success> searchAreasHome(String keyword);
}

class HomeRemoteDataSourceImpl extends RemoteBaseImpl
    implements HomeRemoteDataSource {
  final WeatherService weatherService;

  HomeRemoteDataSourceImpl({this.weatherService});

  @override
  Future<List<AreaItem>> fetchListExperiences() async {
    setPublicToken();
    final response = await dio.get(endPointGetExperiences).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<AreaItem>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => AreaItem.fromJson(v)).toList();
    });
  }

  @override
  Future<Success> addFavorite(
      {String id, bool isFavorite, FavoriteType favoriteType}) async {
    setPrivateToken();
    final data = DataFormUtil.addFavorite(
        id: id, isFavorite: isFavorite, favoriteType: favoriteType);
    final response =
        await dio.post(endPointAddFavorite, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<WeatherInfo> fetchWeatherInfo({String lat, String lon}) async {
    final response = await dio
        .get(
            weatherService.getLocationKey(double.parse(lat), double.parse(lon)))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    if (response.statusCode == CODE_SUCCESS) {
      return fetchWeatherData(response.data['Key']);
    } else {
      print('RemoteDataFailure ${response.statusCode}');
      throw RemoteDataFailure(
          errorCode: response.statusCode.toString(),
          errorMessage: response.data);
    }
  }

  Future<WeatherInfo> fetchWeatherData(String key) async {
    final response = await dio
        .get(weatherService.getWeatherEndPoint(key))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    if (response.statusCode == CODE_SUCCESS) {
      return WeatherInfo.fromJson(response.data[0]);
    } else {
      print('RemoteDataFailure ${response.statusCode}');
      throw RemoteDataFailure(
          errorCode: response.statusCode.toString(),
          errorMessage: response.data);
    }
  }

  @override
  Future<Success> searchAreasHome(String keyword) async {
    setPublicToken();
    final data = DataFormUtil.searchKeywordFormData(keyword: keyword);
    final response =
        await dio.post(endPointSearch, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> filterAreasHome(List<String> filter) async {
    setPublicToken();
    final response =
        await dio.post(endPointFilter, data: filter).catchError((error) {
      print('Catched errro $error');
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<List<ActivityModel>> fetchListWeekendActivities(
      {int pageIndex, String experienceId, dynamic filterData}) async {
    setPrivateToken();
    final response = await dio.get(endPointGetWeekendActivties,
        queryParameters: {
          'experience_id': experienceId,
          PARAM_FILTER_FACILITY: filterData
        }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<ActivityModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => ActivityModel.fromJson(v)).toList();
    });
  }

  @override
  Future<CommunityModel> fetchListCommunity(
      {int pageIndex,
      String experienceId,
      Map<int, Map> filterAdv,
      String amenityId,
      String cateId,
      dynamic filterData}) async {
    setPrivateToken();

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
    } catch (e) {
      LogUtils.d(e);
    }

    final response = await dio
        .get(endPointGetCommunity,
            queryParameters: DataFormUtil.genParamsCommunityPost(
                page: pageIndex,
                limit: 100,
                filterFacility: filterData,
                filterAdv: filterAdvData,
                amenityId: amenityId,
                experId: experienceId,
                category: cateId))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<CommunityModel>(response, (responseData) {
      return CommunityModel.fromJson(responseData.data);
    });
  }
}

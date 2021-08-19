import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/utils.dart';
import '../model/activity_model.dart';
import '../model/area_item.dart';
import '../model/community_model.dart';
import '../model/places_model.dart';
import '../model/suggestion.dart';
import '../model/weather_info.dart';
import '../source/failure.dart';
import '../source/local/home_local_datasource.dart';
import '../source/remote/home_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class HomeRepository {
  /// GET API
  Future<Either<Failure, List<AreaItem>>> fetchListExperiences();

  Future<Either<Failure, WeatherInfo>> fetchWeather({String lat, String lon});

  Future<Either<Failure, List<ActivityModel>>> fetchListWeekendActivities(
      {int pageIndex, String experienceId, dynamic filterData});

  Future<Either<Failure, CommunityModel>> fetchListCommunity(
      {int pageIndex,
      String experienceId,
      Map<int, Map> filterAdv,
      String amenityId,
      String cateId,
      dynamic filterData});

  /// POST API
  Future<Either<Failure, Success>> addFavorite(
      String id, bool isFavorite, FavoriteType favoriteType);

  Future<Either<Failure, Success>> searchAreasHome(String keyword);

  Future<Either<Failure, Success>> filterAreasHome(List<String> filter);

  ///Local Data
  void saveExperiences(List<AreaItem> listAreas);

  List<AreaItem> getExperiences();

  void saveWeatherInfo(WeatherInfo weatherInfo);

  WeatherInfo getWeatherInfo();

  void saveCommunityListInfo(CommunityModel communityModel);

  CommunityModel getCommunityListInfo();

  void saveAmenitiesInfo(List<AmenityInfo> amenities);

  List<AmenityInfo> getAmenities();

  void saveActivities(List<ActivityModel> items);

  List<ActivityModel> getActivities();
}

class HomeRepositoryImpl extends Repository implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSrc;
  final LocationWrapper locationWrapper;

  HomeRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSrc,
    this.locationWrapper,
  });

  @override
  Future<Either<Failure, List<AreaItem>>> fetchListExperiences() async {
    if (await networkInfo.isConnected) {
      try {
        final listAreas = await remoteDataSource.fetchListExperiences();
        saveExperiences(listAreas);
        return Right(listAreas);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  List<AreaItem> getExperiences() {
    return localDataSrc.getExperiences();
  }

  @override
  void saveExperiences(List<AreaItem> listAreas) {
    return localDataSrc.saveExperiences(listAreas);
  }

  @override
  Future<Either<Failure, WeatherInfo>> fetchWeather(
      {String lat, String lon}) async {
    return catchData<WeatherInfo>(() async {
      final weatherInfo =
          await remoteDataSource.fetchWeatherInfo(lat: lat, lon: lon);
      saveWeatherInfo(weatherInfo);
      return weatherInfo;
    });
  }

  @override
  Future<Either<Failure, Success>> addFavorite(
      String id, bool isFavorite, FavoriteType favoriteType) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.addFavorite(
          id: id, isFavorite: isFavorite, favoriteType: favoriteType);
      return data;
    });
  }

  @override
  WeatherInfo getWeatherInfo() {
    return localDataSrc.getWeatherInfo();
  }

  @override
  void saveWeatherInfo(WeatherInfo weatherInfo) {
    return localDataSrc.saveWeatherInfo(weatherInfo);
  }

  @override
  Future<Either<Failure, Success>> searchAreasHome(String keyword) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.searchAreasHome(keyword);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> filterAreasHome(List<String> filter) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.filterAreasHome(filter);
      return data;
    });
  }

  @override
  Future<Either<Failure, CommunityModel>> fetchListCommunity(
      {int pageIndex,
      String experienceId,
      String amenityId,
      Map<int, Map> filterAdv,
      String cateId,
      dynamic filterData}) async {
    return catchData<CommunityModel>(() async {
      final data = await remoteDataSource.fetchListCommunity(
          cateId: cateId,
          experienceId: experienceId,
          filterAdv: filterAdv,
          pageIndex: pageIndex,
          amenityId: amenityId,
          filterData: filterData);

      data.allPost.forEach((element) async {
        if (element.place != null) {
          element.place.eta = await _estimateTime(element.place);
          element.place.distance = await _distance(element.place);
          element.place.etaCar = await _estimateTimeCar(element.place);
        }
      });
      data.trendingPost.forEach((element) async {
        if (element.place != null) {
          element.place.eta = await _estimateTime(element.place);
          element.place.distance = await _distance(element.place);
          element.place.etaCar = await _estimateTimeCar(element.place);
        }
      });

      saveCommunityListInfo(data);
      return data;
    });
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> fetchListWeekendActivities(
      {int pageIndex, String experienceId, dynamic filterData}) async {
    return catchData<List<ActivityModel>>(() async {
      final data = await remoteDataSource.fetchListWeekendActivities(
          experienceId: experienceId,
          pageIndex: pageIndex,
          filterData: filterData);
      saveActivities(data);
      return data;
    });
  }

  @override
  CommunityModel getCommunityListInfo() {
    return localDataSrc.getCommunityListInfo();
  }

  @override
  void saveCommunityListInfo(CommunityModel communityModel) {
    return localDataSrc.saveCommunityListInfo(communityModel);
  }

  @override
  List<AmenityInfo> getAmenities() {
    return localDataSrc.getAmenities();
  }

  @override
  void saveAmenitiesInfo(List<AmenityInfo> amenities) {
    return localDataSrc.saveAmenitiesInfo(amenities);
  }

  @override
  List<ActivityModel> getActivities() {
    return localDataSrc.getActivities();
  }

  @override
  void saveActivities(List<ActivityModel> items) {
    return localDataSrc.saveActivities(items);
  }

  Future<String> _estimateTime(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTime(distance);
  }

  Future<String> _estimateTimeCar(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTimeCar(distance);
  }

  Future<double> _distance(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return distance;
  }
}

enum FavoriteType { COMMUNITY_POST, AMENITY, EVENT }

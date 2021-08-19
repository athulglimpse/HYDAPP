import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../ui/assets/asset_see_all/asset_see_all_grid_page.dart';
import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/utils.dart';
import '../model/asset_detail.dart';
import '../model/places_model.dart';
import '../source/failure.dart';
import '../source/local/asset_local_datasource.dart';
import '../source/remote/asset_remote_data_source.dart';
import 'repository.dart';

abstract class AssetRepository {
  ///GET API
  Future<Either<Failure, AssetDetail>> fetchAmenityDetail(String id);
  Future<Either<Failure, List<PlaceModel>>> fetchAmenities(
      {ViewAssetType viewAssetType,
      dynamic filter,
      String experiId,
      Map<int, Map> filterAdv,
      String category});
  Future<Either<Failure, List<PlaceModel>>> fetchAmenitiesAlsoLike(String id);
  Future<Either<Failure, List<AssetDetail>>> fetchSearchAsset(String content);

  ///Local Data
  AssetDetail getAssetDetail(String it);

  void saveAssetDetail(AssetDetail detail, String id);

  List<PlaceModel> getAssets(ViewAssetType viewAssetType);

  void saveAssets(List<PlaceModel> assets, ViewAssetType viewAssetType);
}

class AssetRepositoryImpl extends Repository implements AssetRepository {
  final LocationWrapper locationWrapper;
  final AssetRemoteDataSource remoteDataSource;
  final AssetLocalDataSource localDataSrc;

  AssetRepositoryImpl(
      {@required this.remoteDataSource,
      this.locationWrapper,
      @required this.localDataSrc});

  @override
  Future<Either<Failure, AssetDetail>> fetchAmenityDetail(String id) async {
    return catchData<AssetDetail>(() async {
      final data = await remoteDataSource.fetchAmenityDetail(id);
      data.eta = await _estimateTime(data);
      data.etaCar = await _estimateTimeCar(data);
      data.distance = await _distance(data);
      saveAssetDetail(data, data.id.toString());
      return data;
    });
  }

  @override
  Future<Either<Failure, List<AssetDetail>>> fetchSearchAsset(
      String content) async {
    return catchData<List<AssetDetail>>(() async {
      final data = await remoteDataSource.fetchSearchAsset(content);
      data?.forEach((e) async {
        e.eta = await _estimateTime(e);
        e.etaCar = await _estimateTimeCar(e);
        e.distance = await _distance(e);
      });
      return data;
    });
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> fetchAmenities(
      {ViewAssetType viewAssetType,
      dynamic filter,
      String experiId,
      Map<int, Map> filterAdv,
      String category}) async {
    return catchData<List<PlaceModel>>(() async {
      final data = await remoteDataSource.fetchAmenities(
          viewAssetType: viewAssetType,
          filter: filter,
          experienceId: experiId,
          filterAdv: filterAdv,
          category: category);
      data?.forEach((e) async {
        e.eta = await _estimateTime(e);
        e.etaCar = await _estimateTimeCar(e);
        e.distance = await _distance(e);
      });
      saveAssets(data, viewAssetType);
      return data;
    });
  }

  Future<String> _estimateTime(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTime(distance);
  }

  Future<double> _distance(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return distance;
  }

  Future<String> _estimateTimeCar(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTimeCar(distance);
  }

  @override
  Future<Either<Failure, List<PlaceModel>>> fetchAmenitiesAlsoLike(
      String id) async {
    return catchData<List<PlaceModel>>(() async {
      final assets = await remoteDataSource.fetchAmenitiesAlsoLike(id);
      assets?.forEach((e) async {
        e.eta = await _estimateTime(e);
        e.etaCar = await _estimateTimeCar(e);
      });
      return assets;
    });
  }

  @override
  void saveAssets(List<PlaceModel> assets, ViewAssetType viewAssetType) {
    return localDataSrc.saveAssets(assets, viewAssetType);
  }

  @override
  List<PlaceModel> getAssets(ViewAssetType viewAssetType) {
    final assets = localDataSrc.getAssets(viewAssetType);
    return assets;
  }

  @override
  AssetDetail getAssetDetail(String id) {
    final detail = localDataSrc.getAssetDetail(id);
    return detail;
  }

  @override
  void saveAssetDetail(AssetDetail detail, String id) {
    return localDataSrc.saveAssetDetail(detail, id);
  }
}

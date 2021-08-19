import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

import '../model/amenity_model.dart';
import '../model/direction_model.dart';
import '../model/distance_matrix_model.dart';
import '../model/location_model.dart';
import '../source/failure.dart';
import '../source/local/location_local_datasource.dart';
import '../source/remote/location_remote_data_source.dart';
import 'repository.dart';

abstract class LocationRepository {
  ///GET API
  Future<Either<Failure, DirectionModel>> guideDirection(
      LocationData myLocation, double lat, double long);

  Future<Either<Failure, List<AmenityModel>>> searchNearBy({
    double lat,
    double long,
    String content,
    int experience_id,
    double distances,
  });

  Future<Either<Failure, DistanceMatrixModel>> estDistanceFromMyLocation(
      LocationModel myLocation,
      Map<String, LocationModel> listDestination,
      TravelMode travelMode);

  ///Local Data
  ///
  List<AmenityModel> getNearBy();

  void saveNearBy(List<AmenityModel> amenities);
}

class LocationRepositoryImpl extends Repository implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSrc;

  LocationRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, DistanceMatrixModel>> estDistanceFromMyLocation(
      LocationModel myLocation,
      Map<String, LocationModel> listDestination,
      TravelMode travelMode) async {
    return catchData<DistanceMatrixModel>(() async {
      final data = await remoteDataSource.estDistanceFromMyLocation(
          myLocation, listDestination, travelMode);
      return data;
    });
  }

  @override
  Future<Either<Failure, List<AmenityModel>>> searchNearBy({
    double lat,
    double long,
    String content,
    int experience_id,
    double distances,
  }) async {
    return catchData<List<AmenityModel>>(() async {
      final data = await remoteDataSource.searchNearBy(
          lat: lat,
          long: long,
          content: content,
          experience_id: experience_id,
          distances: distances);
      saveNearBy(data);
      return data;
    });
  }

  @override
  Future<Either<Failure, DirectionModel>> guideDirection(
      LocationData myLocation, double lat, double long) async {
    return catchData<DirectionModel>(() async {
      final data = await remoteDataSource.guideDirection(myLocation, lat, long);
      return data;
    });
  }

  @override
  List<AmenityModel> getNearBy() {
    return localDataSrc.getNearBy();
  }

  @override
  void saveNearBy(List<AmenityModel> amenities) {
    return localDataSrc.saveNearBy(amenities);
  }
}

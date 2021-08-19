import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/activity_model.dart';
import '../source/failure.dart';
import '../source/local/activity_local_datasource.dart';
import '../source/remote/activity_remote_data_source.dart';
import 'repository.dart';

abstract class ActivityRepository {
  ///GET API
  Future<Either<Failure, ActivityModel>> fetchActivityDetail(String id);

  Future<Either<Failure, List<ActivityModel>>> fetchActivityAlsoLike(
      {String id});

  ///Local Data
  ActivityModel getActivityDetail(String id);

  List<ActivityModel> getActivityAlsoLike({String id});

  void saveActivityDetail(ActivityModel ActivityDetailModel);

  void saveActivityAlsoLike(List<ActivityModel> amenities, String id);
}

class ActivityRepositoryImpl extends Repository implements ActivityRepository {
  final ActivityLocalDataSource localDataSrc;
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, List<ActivityModel>>> fetchActivityAlsoLike(
      {String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final assets = await remoteDataSource.fetchActivityAlsoLike(id: id);
        saveActivityAlsoLike(assets, id);
        return Right(assets);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ActivityModel>> fetchActivityDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final assets = await remoteDataSource.fetchActivityDetail(id);
        saveActivityDetail(assets);
        return Right(assets);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  void saveActivityDetail(ActivityModel ActivityDetailModel) {
    return localDataSrc.saveActivityDetail(ActivityDetailModel);
  }

  @override
  List<ActivityModel> getActivityAlsoLike({String id}) {
    final amenities = localDataSrc.getActivityAlsoLike(id: id);
    return amenities;
  }

  @override
  void saveActivityAlsoLike(List<ActivityModel> amenities, String id) {
    return localDataSrc.saveActivityAlsoLike(amenities, id);
  }

  @override
  ActivityModel getActivityDetail(String id) {
    final ActivityDetailModel = localDataSrc.getActivityDetail(id);
    return ActivityDetailModel;
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/save_item_model.dart';
import '../model/user_community_model.dart';
import '../source/failure.dart';
import '../source/local/profile_local_datasource.dart';
import '../source/remote/profile_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class ProfileRepository {
  ///GET API
  Future<Either<Failure, List<SaveItemModel>>> fetchSaveItem(String id);
  Future<Either<Failure, List<UserCommunityModel>>> fetchMyCommunity(String userId);
  Future<Either<Failure, Success>> deActivateAccount(String reason);

  ///Local Data
  List<SaveItemModel> getListSaveItem(String experienceId);

  Future<void> saveListSaveItem(String experienceId, List saveItem);

  List<UserCommunityModel> getListMyCommunity(String id);

  Future<void> saveListMyCommunity(String id, List userCommunity);
}

class ProfileRepositoryImpl extends Repository implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSrc;

  ProfileRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, List<SaveItemModel>>> fetchSaveItem(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final saveItem = await remoteDataSource.fetchSaveItem(id);
        await saveListSaveItem(id, saveItem);
        return Right(saveItem);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> deActivateAccount(String reason) async{
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.deActivateAccount(reason);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserCommunityModel>>> fetchMyCommunity(String userId) async{
    if (await networkInfo.isConnected) {
      try {
        final saveItem = await remoteDataSource.fetchMyCommunity(userId);
        await saveListMyCommunity(userId, saveItem);
        return Right(saveItem);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<void> saveListSaveItem(String id, List saveItem) async {
    return localDataSrc.saveSaveItem(id, saveItem);
  }

  @override
  List<SaveItemModel> getListSaveItem(String experienceId) {
    final saveItemModel = localDataSrc.getSaveItem(experienceId);
    return saveItemModel;
  }

  @override
  List<UserCommunityModel> getListMyCommunity(String id) {
    final saveItemModel = localDataSrc.getMyCommunity(id);
    return saveItemModel;
  }

  @override
  Future<void> saveListMyCommunity(String id, List userCommunity) {
    return localDataSrc.saveMyCommunity(id, userCommunity);
  }


}

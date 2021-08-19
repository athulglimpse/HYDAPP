import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../model/notification_history_model.dart';
import '../model/notification_setting_model.dart';
import '../source/failure.dart';
import '../source/local/notification_local_datasource.dart';
import '../source/remote/notification_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class NotificationRepository {
  ///GET API
  Future<Either<Failure, List<NotificationSettingModel>>>
      fetchNotificationSetting();

  Future<Either<Failure, List<NotificationHistoryModel>>>
      fetchNotificationHistory({int pageIndex, int limit});

  ///POST API
  Future<Either<Failure, Success>> submitNotificationSetting(
      List<NotificationSettingModel> list);

  Future<Either<Failure, Success>> turnOffNotificationFromOwner(
      String postId, String action, String type);

  Future<Either<Failure, Success>> removeNotificationFromFeed(String id);

  ///Local API
  void saveListNotificationItems(List<NotificationSettingModel> list);

  List<NotificationSettingModel> getLocalListNotificationItems();

  void saveListNotificationHistoryItems(List<NotificationHistoryModel> list);

  List<NotificationHistoryModel> getLocalListNotificationHistoryItems();
}

class NotificationRepositoryImpl extends Repository
    implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSrc;

  NotificationRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, Success>> submitNotificationSetting(
      List<NotificationSettingModel> list) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.submitListNotificationItems(list));
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<NotificationSettingModel>>>
      fetchNotificationSetting() async {
    if (await networkInfo.isConnected) {
      try {
        final listItems = await remoteDataSource.fetchListNotificationItems();
        saveListNotificationItems(listItems);
        return Right(listItems);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<NotificationHistoryModel>>>
      fetchNotificationHistory({int pageIndex, int limit}) async {
    if (await networkInfo.isConnected) {
      try {
        final listItems =
            await remoteDataSource.fetchListNotificationHistoryItems(
                pageIndex: pageIndex, limit: limit);
        if (pageIndex == 0) {
          saveListNotificationHistoryItems(listItems);
        }
        return Right(listItems);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  void saveListNotificationItems(List<NotificationSettingModel> list) {
    return localDataSrc.saveListNotificationItems(list);
  }

  @override
  List<NotificationSettingModel> getLocalListNotificationItems() {
    final listInterest = localDataSrc.getListNotificationItems();
    return listInterest;
  }

  @override
  void saveListNotificationHistoryItems(List<NotificationHistoryModel> list) {
    return localDataSrc.saveListNotificationHistoryItems(list);
  }

  @override
  List<NotificationHistoryModel> getLocalListNotificationHistoryItems() {
    final listInterest = localDataSrc.getListNotificationHistoryItems();
    return listInterest;
  }

  @override
  Future<Either<Failure, Success>> removeNotificationFromFeed(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.removeNotificationFromFeed(id);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> turnOffNotificationFromOwner(
      String postId, String action, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.turnOffNotificationFromOwner(
            postId, action, type);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

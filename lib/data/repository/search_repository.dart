import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../model/data_models/search_result_data_model.dart';
import '../model/recent_model.dart';
import '../source/failure.dart';
import '../source/local/search_local_datasource.dart';
import '../source/remote/search_remote_data_source.dart';
import 'repository.dart';

abstract class SearchRepository {
  ///GET API
  Future<Either<Failure, SearchResultDataModel>> search(
      String content, int experienceId);

  Future<Either<Failure, List<RecentModel>>> recent(
    int itemsPerPage,
    String page,
    int timestamp,
  );

  ///Local Data
  List<RecentModel> getRecentSearch();

  void saveRecentSearch(List<RecentModel> items);
}

class SearchRepositoryImpl extends Repository implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  List<RecentModel> getRecentSearch() {
    return localDataSource.getRecentSearch();
  }

  @override
  void saveRecentSearch(List<RecentModel> items) {
    localDataSource.saveRecentSearch(items);
  }

  @override
  Future<Either<Failure, List<RecentModel>>> recent(
      int itemsPerPage, String page, int timestamp) async {
    if (await networkInfo.isConnected) {
      try {
        final assets =
            await remoteDataSource.recent(itemsPerPage, page, timestamp);
        return Right(assets);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, SearchResultDataModel>> search(
      String content, int experienceId) async {
    if (await networkInfo.isConnected) {
      try {
        final assets = await remoteDataSource.search(content, experienceId);
        return Right(assets);
      } on RemoteDataFailure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

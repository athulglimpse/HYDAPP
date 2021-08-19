import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../model/personalization_item.dart';
import '../source/failure.dart';
import '../source/local/personalize_local_datasource.dart';
import '../source/remote/personalize_remote_data_source.dart';
import 'repository.dart';

abstract class PersonalizeRepository {
  ///GET API
  Future<Either<Failure, List<PersonalizationItem>>>
      fetchListPersonalizeItems();

  ///Local API
  void saveListPersonalizeItems(List<PersonalizationItem> list);

  List<PersonalizationItem> getLocalListPersonalizeItems();
}

class PersonalizeRepositoryImpl extends Repository
    implements PersonalizeRepository {
  final PersonalizeRemoteDataSource remoteDataSource;
  final PersonalizeLocalDataSource localDataSrc;
  PersonalizeRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, List<PersonalizationItem>>>
      fetchListPersonalizeItems() async {
    if (await networkInfo.isConnected) {
      try {
        final listItems = await remoteDataSource.fetchListPersonalizeItems();
        saveListPersonalizeItems(listItems);
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
  void saveListPersonalizeItems(List<PersonalizationItem> list) {
    return localDataSrc.saveListPersonalizeItems(list);
  }

  @override
  List<PersonalizationItem> getLocalListPersonalizeItems() {
    final listInterest = localDataSrc.getListPersonalizeItems();
    return listInterest;
  }
}

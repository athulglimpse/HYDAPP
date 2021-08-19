import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/app_config.dart';
import '../model/country.dart';
import '../source/failure.dart';
import '../source/local/config_local_datasource.dart';
import '../source/remote/config_remote_data_source.dart';
import 'repository.dart';

abstract class ConfigRepository {
  ///Get API
  Future<Either<Failure, AppConfig>> fetchAppConfig();

  Future<Either<Failure, List<Country>>> getCountryCode();

  /// Local API
  void saveAppConfig(AppConfig config);

  AppConfig getAppConfig();
}

class ConfigRepositoryImpl extends Repository implements ConfigRepository {
  final ConfigRemoteDataSource remoteDataSource;
  final ConfigLocalDataSource localDataSrc;

  ConfigRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, AppConfig>> fetchAppConfig() {
    return catchData<AppConfig>(() async {
      final data = await remoteDataSource.fetchAppConfig();
      //update AppConfig to cache
      saveAppConfig(data);
      return data;
    });
  }

  //Store AppConfig
  @override
  void saveAppConfig(AppConfig config) {
    return localDataSrc.saveAppConfig(config);
  }

  @override
  AppConfig getAppConfig() {
    final appConfig = localDataSrc.getAppConfig();
    return appConfig;
  }

  @override
  Future<Either<Failure, List<Country>>> getCountryCode() async {
    final data = await rootBundle.loadString('assets/json/country.json');
    final arr = parseJson(data);
    try {
      return Right(arr);
    } on RemoteDataFailure catch (e) {
      print(e.errorMessage);
      return Left(e);
    }
  }

  List<Country> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Country>((json) => Country.fromJson(json)).toList();
  }
}

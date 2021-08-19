import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../model/language.dart';
import '../model/static_content.dart';
import '../source/failure.dart';
import '../source/local/static_content_local_datasource.dart';
import '../source/remote/static_remote_data_source.dart';
import 'repository.dart';

abstract class StaticContentRepository {
  ///GET API
  Future<Either<Failure, StaticContent>> fetchStaticContent();

  ///Local API
  void saveStaticContent(StaticContent staticContent);

  StaticContent getLocalStaticContent();

  Future<Either<Failure, List<Language>>> getLanguage();
}

class StaticContentRepositoryImpl extends Repository
    implements StaticContentRepository {
  final StaticContentRemoteDataSource remoteDataSource;
  final StaticContentLocalDataSource localDataSrc;
  StaticContentRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, StaticContent>> fetchStaticContent() {
    return catchData<StaticContent>(() async {
      final data = await remoteDataSource.fetchStaticContent();
      saveStaticContent(data);
      return data;
    });
  }

  @override
  void saveStaticContent(StaticContent staticContent) {
    return localDataSrc.saveStaticContent(staticContent);
  }

  @override
  StaticContent getLocalStaticContent() {
    final listInterest = localDataSrc.getStaticContent();
    return listInterest;
  }

  //todo hardcode json interest
  @override
  Future<Either<Failure, List<Language>>> getLanguage() async {
    final data = await rootBundle.loadString('assets/json/language.json');
    final arr = parseJson(data);
    try {
      return Right(arr);
    } on RemoteDataFailure catch (e) {
      print(e.errorMessage);
      return Left(e);
    }
  }

  List<Language> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response).cast<Map<String, dynamic>>();
    return parsed.map<Language>((json) => Language.fromJson(json)).toList();
  }
}

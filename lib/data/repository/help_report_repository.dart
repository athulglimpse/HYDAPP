import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../model/help_report_model.dart';
import '../source/failure.dart';
import '../source/local/help_report_local_datasource.dart';
import '../source/remote/help_report_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class HelpAndReportRepository {
  ///Get API
  Future<Either<Failure, Success>> sendHelpItems(String content, String topicId,
      String email, String mobile, String dialCode);

  Future<Either<Failure, Success>> sendReportItems(
      String des, String issueType, List<int> idPhotos);

  Future<Either<Failure, List<HelpReportModel>>> fetchHelpItems();

  Future<Either<Failure, List<HelpReportModel>>> fetchReportItems();

  /// Local API
  void saveHelpItems(List<HelpReportModel> items);

  List<HelpReportModel> getHelpItems();

  void saveReportItems(List<HelpReportModel> items);

  List<HelpReportModel> getReportItems();
}

class HelpAndReportRepositoryImpl extends Repository
    implements HelpAndReportRepository {
  final HelpAndReportRemoteDataSource remoteDataSource;
  final HelpReportLocalDataSource localDataSrc;

  HelpAndReportRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSrc});

  @override
  Future<Either<Failure, List<HelpReportModel>>> fetchHelpItems() {
    return catchData<List<HelpReportModel>>(() async {
      final data = await remoteDataSource.fetchHelpItems();
      saveHelpItems(data);
      return data;
    });
  }

  @override
  Future<Either<Failure, List<HelpReportModel>>> fetchReportItems() {
    return catchData<List<HelpReportModel>>(() async {
      final data = await remoteDataSource.fetchReportItems();
      saveReportItems(data);
      return data;
    });
  }

  @override
  List<HelpReportModel> getHelpItems() {
    return localDataSrc.helpItems();
  }

  @override
  List<HelpReportModel> getReportItems() {
    return localDataSrc.reportItems();
  }

  @override
  void saveHelpItems(List<HelpReportModel> items) {
    localDataSrc.saveHelpItems(items);
  }

  @override
  void saveReportItems(List<HelpReportModel> items) {
    localDataSrc.saveReportItems(items);
  }

  @override
  Future<Either<Failure, Success>> sendHelpItems(String content, String topicId,
      String email, String mobile, String dialCode) async {
    return catchData<Success>(() async {
      final data = await remoteDataSource.sendHelp(
          content, topicId, email, mobile, dialCode);
      return data;
    });
  }

  @override
  Future<Either<Failure, Success>> sendReportItems(
      String des, String issueType, List<int> idPhotos) {
    return catchData<Success>(() async {
      final data =
          await remoteDataSource.sendReportIssue(des, issueType, idPhotos);
      return data;
    });
  }
}

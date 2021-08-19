import '../../model/help_report_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class HelpAndReportRemoteDataSource {
  ///GET API
  Future<List<HelpReportModel>> fetchHelpItems();

  Future<List<HelpReportModel>> fetchReportItems();

  Future<Success> sendHelp(String content, String topicId, String email,
      String mobile, String dialCode);

  Future<Success> sendReportIssue(
      String des, String issueType, List<int> idPhotos);
}

class HelpAndReportRemoteDataSourceImpl extends RemoteBaseImpl
    implements HelpAndReportRemoteDataSource {
  HelpAndReportRemoteDataSourceImpl();

  @override
  Future<List<HelpReportModel>> fetchHelpItems() async {
    setPrivateToken();
    final response = await dio.get(endPointGetHelp).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<HelpReportModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => HelpReportModel.fromJson(v)).toList();
    });
  }

  @override
  Future<List<HelpReportModel>> fetchReportItems() async {
    setPrivateToken();
    final response = await dio.get(endPointGetReportIssue).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<HelpReportModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap.map((v) => HelpReportModel.fromJson(v)).toList();
    });
  }

  @override
  Future<Success> sendHelp(String content, String topicId, String email,
      String mobile, String dialCode) async {
    setPrivateToken();
    final response = await dio.post(endPointHelp, data: {
      'content': content,
      'help_topic': topicId,
      'email': email,
      'mobile': mobile,
      'dial_code': dialCode,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> sendReportIssue(
      String des, String issueType, List<int> idPhotos) async {
    setPrivateToken();
    final response = await dio.post(endPointReportIssue, data: {
      'description': des,
      'issue_type': issueType,
      'photo': idPhotos,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }
}

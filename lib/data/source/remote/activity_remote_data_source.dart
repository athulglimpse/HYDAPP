import '../../../common/localization/lang.dart';
import '../../model/activity_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class ActivityRemoteDataSource {
  ///GET API
  Future<ActivityModel> fetchActivityDetail(String id);

  Future<List<ActivityModel>> fetchActivityAlsoLike({String id});
}

class ActivityRemoteDataSourceImpl extends RemoteBaseImpl
    implements ActivityRemoteDataSource {
  ActivityRemoteDataSourceImpl();

  @override
  Future<ActivityModel> fetchActivityDetail(String id) async {
    setPrivateToken();
    final response = await dio
        .get(endPointGetAmenityDetail
            .format([id, (DateTime.now().toIso8601String())]))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<ActivityModel>(response, (responseData) {
      return ActivityModel.fromJson(responseData.data);
    });
  }

  @override
  Future<List<ActivityModel>> fetchActivityAlsoLike({String id}) async {
    setPrivateToken();
    final response =
        await dio.get(endPointGetWeekendActivitiesAlsoLike, queryParameters: {
      'id': id,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<ActivityModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => ActivityModel.fromJson(v))?.toList() ?? [];
    });
  }
}

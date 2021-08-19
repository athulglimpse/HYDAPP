
import '../../model/save_item_model.dart';
import '../../model/user_community_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class ProfileRemoteDataSource {
  ///POST API
  Future<Success> deActivateAccount(String reason);

  ///GET API
  Future<List<SaveItemModel>> fetchSaveItem(String id);
  Future<List<UserCommunityModel>> fetchMyCommunity(String userId);
}

class ProfileRemoteDataSourceImpl extends RemoteBaseImpl
    implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl();

  @override
  Future<List<SaveItemModel>> fetchSaveItem(String id) async {
    setPrivateToken();
    final response = await dio.get(endPointGetSaveItem, queryParameters: {
      'experience': id,
      'page': 0,
      't': DateTime.now().toIso8601String(),
      'items_per_page': 10
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<SaveItemModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => SaveItemModel.fromJson(v))?.toList() ?? [];
    });
  }

  @override
  Future<List<UserCommunityModel>> fetchMyCommunity(String userId) async{
    setPrivateToken();
    final response = await dio.get(endPointGetMyCommunity, queryParameters: {
      'limit': 10,
      'page': 0,
      'sort[created]': 'desc'
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<UserCommunityModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => UserCommunityModel.fromJson(v))?.toList() ?? [];
    });
  }

  @override
  Future<Success> deActivateAccount(String reason) async {
    setPrivateToken();
    final response = await dio.post(endPointPostDeActiveAccount,
        data: {'reason': reason}).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });


    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }
}

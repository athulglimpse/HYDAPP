import '../../../common/localization/lang.dart';
import '../../model/amenity_detail_model.dart';
import '../../model/data_models/search_result_data_model.dart';
import '../../model/recent_model.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class SearchRemoteDataSource {
  ///GET API
  Future<SearchResultDataModel> search(String content, int experienceId);

  Future<List<RecentModel>> recent(
    int itemsPerPage,
    String page,
    int timestamp,
  );
}

class SearchRemoteDataSourceImpl extends RemoteBaseImpl
    implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl();

  @override
  Future<SearchResultDataModel> search(String content, int experienceId) async {
    setPrivateToken();
    final response =
        await dio.get(endPointSearchGroupByAsset, queryParameters: {
          'content': (content == null || content.isEmpty) ? '[]' : content,
      'page': 0,
      'items_per_page': 10,
      't': DateTime.now().microsecondsSinceEpoch,
      'experience_id': experienceId
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<SearchResultDataModel>(response, (responseData) {
      return SearchResultDataModel.fromJson(responseData.data);
    });
  }

  @override
  Future<List<RecentModel>> recent(
      int itemsPerPage, String page, int timestamp) async {
    setPrivateToken();
    final response = await dio.get(endPointSearchRecentAsset, queryParameters: {
      'page': page,
      'items_per_page': itemsPerPage,
      't': DateTime.now().microsecondsSinceEpoch,
    }).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<List<RecentModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => RecentModel.fromJson(v))?.toList() ?? [];
    });
  }
}

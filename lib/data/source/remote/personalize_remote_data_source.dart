import '../../model/personalization_item.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class PersonalizeRemoteDataSource {
  ///GET API
  Future<List<PersonalizationItem>> fetchListPersonalizeItems();
}

class PersonalizeRemoteDataSourceImpl extends RemoteBaseImpl
    implements PersonalizeRemoteDataSource {
  PersonalizeRemoteDataSourceImpl();

  @override
  Future<List<PersonalizationItem>> fetchListPersonalizeItems() async {
    setPublicToken();
    final response = await dio.get(endPointGetPersonalize).catchError((error) {

      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<PersonalizationItem>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data;
      return strMap?.map((v) => PersonalizationItem.fromJson(v))?.toList() ??
          [];
    });
  }
}

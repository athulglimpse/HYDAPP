import '../../model/static_content.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class StaticContentRemoteDataSource {
  ///GET API
  Future<StaticContent> fetchStaticContent();
}

class StaticContentRemoteDataSourceImpl extends RemoteBaseImpl
    implements StaticContentRemoteDataSource {
  StaticContentRemoteDataSourceImpl();

  @override
  Future<StaticContent> fetchStaticContent() async {
    setPublicToken();
    final response =
        await dio.get(endPointGetStaticContent).catchError((error) {
      print('Catched errro $error');
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<StaticContent>(response, (responseData) {
      return StaticContent.fromJson(responseData.data);
    });
  }
}

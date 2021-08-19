import '../../model/app_config.dart';
import '../api_end_point.dart';
import '../failure.dart';
import 'remote_base.dart';

abstract class ConfigRemoteDataSource {
  ///GET API
  Future<AppConfig> fetchAppConfig();
}

class ConfigRemoteDataSourceImpl extends RemoteBaseImpl
    implements ConfigRemoteDataSource {
  ConfigRemoteDataSourceImpl();

  @override
  Future<AppConfig> fetchAppConfig() async {
    setPublicToken();
    final response = await dio.get(endPointGetConfig).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<AppConfig>(response, (responseData) {
      return AppConfig.fromJson(responseData.data);
    });
  }
}

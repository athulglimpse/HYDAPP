import 'package:dio/dio.dart';

import '../../../common/di/injection/injector.dart';
import '../../../ui/base/bloc/base_bloc.dart';
import '../../../utils/environment_info.dart';
import '../../../utils/utils.dart';
import '../../model/response_data.dart';
import '../api_end_point.dart';
import '../failure.dart';

abstract class RemoteBase {
  void setPublicToken({Map<String, dynamic> param});
  void setPrivateToken({Map<String, dynamic> param});
  ResponseData toResponseData(Map data);
}

class RemoteBaseImpl implements RemoteBase {
  static const Map<String, String> headerDefinition = {
    'content-type': 'application/json',
    'accept': 'application/json',
  };

  static const X_CSRF_Token = 'X-CSRF-Token';

  //Update user token
  void updateUsrToken(String usrToken) {
    _environmentInfo.updateAccessToken(usrToken);
  }

  final EnvironmentInfo _environmentInfo = sl<EnvironmentInfo>();
  final Dio dio = sl<Dio>()..options.headers.addAll(headerDefinition);

  @override
  void setPublicToken({Map<String, dynamic> param}) {
    // dio.options.headers[X_CSRF_Token] =
    //     Utils.generateMd5(_environmentInfo.apiKey);
    dio.options.headers
        .addAll({X_CSRF_Token: Utils.generateMd5(_environmentInfo.apiKey)});
    if (param != null && param.isNotEmpty) {
      dio.options.headers.addAll(param);
    }
  }

  @override
  ResponseData toResponseData(Map data) {
    return ResponseData.fromJson(data);
  }

  @override
  void setPrivateToken({Map<String, dynamic> param}) {
    dio.options.headers.addAll({X_CSRF_Token: _environmentInfo.accessToken});
    // dio.options.headers[X_CSRF_Token] = _environmentInfo.accessToken;
    if (param != null && param.isNotEmpty) {
      dio.options.headers.addAll(param);
    }
  }

  T checkStatusCode<T>(Response response, Function(ResponseData) action) {
    final responseData = toResponseData(response.data);
    if (responseData.statusCode == CODE_SUCCESS ||
        responseData.statusCode == CODE_CREATE) {
      return action(responseData) as T;
    } else if (responseData.statusCode == CODE_UN_AUTH) {
      sl<BaseBloc>().add(Logout());
      throw RemoteDataFailure(
          errorCode: responseData.statusCode.toString(),
          errorMessage: responseData.message);
    } else {
      // ignore: avoid_print
      print('RemoteDataFailure ${responseData.statusCode}');
      throw RemoteDataFailure(
          errorCode: responseData.statusCode.toString(),
          errorMessage: responseData.message);
    }
  }

//  @override
//  void setupToken(String token) {
//    dio.interceptors
//        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
//      var customHeaders = {'Authorization': 'Bearer $token'}
//        ..addAll(headerDefinition);
//      options.headers.addAll(customHeaders);
//      return options;
//    }));
//  }
}

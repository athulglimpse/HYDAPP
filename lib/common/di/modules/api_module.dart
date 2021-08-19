import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../data/source/api_end_point.dart';
import '../injection/injector.dart';

class ApiModule extends DIModule {
  @override
  Future<void> provides() async {
    sl.registerSingletonAsync<Dio>(() async {
      final dio = Dio(BaseOptions());
      dio.options.connectTimeout = 30000; //30s
      dio.options.receiveTimeout = 30000;
      dio.interceptors.add(LogInterceptor(
          responseBody: !kReleaseMode, requestBody: !kReleaseMode));
      return dio;
    });
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:marvista/data/source/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../common/di/injection/injector.dart';
import '../../utils/network_info.dart';
import '../source/failure.dart';

class Repository {
  final NetworkInfo networkInfo = sl<NetworkInfo>();
  Locale _currentLocal;

  Locale get currentLocal => _currentLocal;
  set currentLocal(Locale currentLocal) => _currentLocal = currentLocal;

  Future<Either<Failure, T>> catchData<T>(Function action) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await action() as T);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      } on DioError catch (e) {
        var mess = e.response.statusMessage;
        if (e?.response?.data != null &&
            e?.response?.data is Map &&
            (e?.response?.data as Map).containsKey('message')) {
          mess = e?.response?.data['message'];
          // UIUtil.showToast(mess);
        }
        return Left(
            RemoteDataFailure(errorCode: e.toString(), errorMessage: mess));
      } on Exception catch (e) {
        return Left(RemoteDataFailure(
            errorCode: e.toString(), errorMessage: e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../common/di/injection/injector.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/api_end_point.dart';
import '../../../data/source/failure.dart';
import '../../../utils/utils.dart';
import '../../base/bloc/base_bloc.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;

  LoginBloc({@required this.userRepository}) : super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield state.copyWith(isEmailValid: Utils.isValidEmail(event.email));
    }
    if (event is PasswordChanged) {
      yield state.copyWith(
          isPasswordValid: Utils.isValidPassword(event.password));
    }
    final deviceToken = await Utils.getDeviceToken();
    final deviceId = await Utils.getDeviceDetails();

    if (event is LoginButtonPressed) {
      final loginResult = await userRepository.login(
          event.username, event.password, deviceId, deviceToken);
      yield* _handleLoginResult(loginResult);
    }
    if (event is LoginSocial) {
      final loginResult = await userRepository.loginSocial(
          event.socialId, event.email, deviceId, event.type, deviceToken);
      yield* _handleLoginResult(loginResult,
          socialMethod: event.type,
          socialId: event.socialId,
          tokenState: DateTime.now().toIso8601String(),
          email: event.email);
    }
    if (event is LinkAccount) {
      final loginResult = await userRepository.linkAccount(
          state.socialId,
          state.email,
          deviceId,
          state.socialMethod,
          event.password,
          deviceToken);
      yield* _handleLoginResult(loginResult);
    }
  }

  LoginStatus _handleError(Failure failure) {
    if (failure is RemoteDataFailure &&
        failure.errorCode == CODE_UN_AUTH.toString()) {
      return LoginStatus.wrongCredential;
    }
    if (failure is RemoteDataFailure &&
        failure.errorCode == CODE_LINK_ACCOUNT.toString()) {
      return LoginStatus.linkAccount;
    }
    return LoginStatus.failed;
  }

  LoginStatus _handleUserProfile(UserInfo user) {
    if (!user.isActivated()) {
      return LoginStatus.notVerified;
    }
    if (user.hasFillPersonalization == 0) {
      return LoginStatus.notChoosePersonalization;
    }
    return LoginStatus.success;
  }

  Stream<LoginState> _handleLoginResult(Either<Failure, UserInfo> result,
      {String socialMethod,
      String email,
      String socialId,
      String tokenState}) async* {
    yield result.fold(
      (failure) => state.submitResult(
          status: _handleError(failure),
          email: email,
          socialId: socialId,
          socialMethod: socialMethod,
          errorMessage: (failure as RemoteDataFailure).errorMessage,
          tokenState: tokenState),
      (userInfo) {
        sl<BaseBloc>().add(OnProfileChange());
        return state.submitResult(
            status: _handleUserProfile(userInfo),
            userInfo: userInfo,
            email: email,
            tokenState: tokenState,
            socialId: socialId,
            socialMethod: socialMethod);
      },
    );
  }
}

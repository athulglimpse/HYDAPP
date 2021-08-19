import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:marvista/data/model/country.dart';
import 'package:marvista/data/model/register_info.dart';
import 'package:marvista/data/repository/config_repository.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/static_content_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';

import '../../../utils/utils.dart';
import 'bloc.dart';

class RegisterOptBloc extends Bloc<RegisterOptEvent, RegisterOptState> {
  final UserRepository userRepository;
  final StaticContentRepository staticContentRepository;
  final ConfigRepository configRepository;

  RegisterOptBloc(
      {@required this.userRepository,
      @required this.configRepository,
      this.staticContentRepository})
      : super(RegisterOptState.initial(
            configRepository, staticContentRepository));

  @override
  Stream<RegisterOptState> mapEventToState(
    RegisterOptEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield state.copyWith(isEmailValid: Utils.isValidEmail(event.email));
    }
    if (event is PasswordChanged) {
      yield state.copyWith(
          isPasswordValid: Utils.isValidPassword(event.password));
    }
    if (event is LoadCountryCode) {
      final result = await configRepository.getCountryCode();
      yield* _handleGetCountryCodeResult(result);
    }
    if (event is LoginButtonPressed) {
      yield state.submitResult(status: null);
      final deviceToken = await Utils.getDeviceToken();
      final deviceId = await Utils.getDeviceDetails();
      final loginResult = await userRepository.login(
          event.username, event.password, deviceId, deviceToken);
      yield* _handleLoginResult(loginResult);
    }
    if (event is RegisterByEmail) {
      final registerResult = await userRepository.register(
          event.firstName,
          event.lastName,
          event.email,
          event.dob,
          event.maritalId,
          event.password,
          event.type,
          event.dialCode,
          event.phone,
          event.socialId,
          event.hasSocialEmail);
      yield* _handleRegisterResult(registerResult, event.email);
    }
    if (event is DoLogin) {
      final result = await userRepository.getMe(accessToken: event.accessToken);
      yield result.fold((l) => state.submitResult(status: _handleError(l)),
          (r) {
        return state.submitResult(
            registerStatus: RegisterStatus.getProfileSuccess, userInfo: r);
      });
    }
  }

  LoginStatus _handleError(Failure failure) {
    if (failure is RemoteDataFailure && failure.errorCode == '401') {
      return LoginStatus.wrongCredential;
    }
    return LoginStatus.failed;
  }

  LoginStatus _handleUserProfile(UserInfo user) {
    if (user.hasFillPersonalization == 0) {
      return LoginStatus.notChoosePersonalization;
    }
//    if (user.company == null) {
//      return LoginStatus.needCompany;
//    } else if (user.membership.status.name == "PENDING") {
//      return LoginStatus.pendingJoinCompany;
//    }
    userRepository.saveCurrentUser(user);
    return LoginStatus.success;
  }

  Stream<RegisterOptState> _handleLoginResult(
    Either<Failure, UserInfo> result,
  ) async* {
    yield result.fold(
      (failure) => state.submitResult(status: _handleError(failure)),
      (userInfo) => state.submitResult(
          status: _handleUserProfile(userInfo), userInfo: userInfo),
    );
  }

  Stream<RegisterOptState> _handleGetCountryCodeResult(
      Either<Failure, List<Country>> result) async* {
    yield result.fold(
      (failure) => state,
      (country) {
        return state.copyWith(countrySelected: country[0]);
      },
    );
  }

  Stream<RegisterOptState> _handleRegisterResult(
      Either<Failure, RegisterInfo> result, String email) async* {
    yield result.fold(
        (failure) => state.submitResult(registerStatus: RegisterStatus.failed),
        (right) {
      if (right.accessToken != null) {
        add(DoLogin(right.accessToken));
        return state.submitResult(
            registerStatus: RegisterStatus.registerSuccess);
      }
      return state.submitResult(registerStatus: RegisterStatus.alreadyRegister);
    });
  }
}

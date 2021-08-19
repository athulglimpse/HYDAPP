import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../data/model/app_config.dart';
import '../../../data/model/country.dart';
import '../../../data/model/register_info.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../utils/date_util.dart';
import '../../../utils/string_util.dart';
import '../../../utils/utils.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final ConfigRepository configRepository;
  static const totalTimeCount = 30;
  StreamSubscription<int> streamController;

  RegisterBloc({
    @required this.userRepository,
    @required this.configRepository,
  }) : super(RegisterState.initial(configRepository, totalTimeCount));

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield state.copyWith(
          isEmailValid: event.email.isEmpty || Utils.isValidEmail(event.email));
    } else if (event is HasSocialEmail) {
      yield state.copyWith(hasSocialEmail: 1);
    } else if (event is OnSelectDOB) {
      yield state.copyWith(selectedDate: event.selectedDate);
    } else if (event is FirstNameChanged) {
      yield state.copyWith(
          isFirstNameValid:
              event.firstName.isEmpty || event.firstName.length >= 3);
    } else if (event is LastNameChanged) {
      yield state.copyWith(
          isLastNameValid:
              event.lastName.isEmpty || event.lastName.length >= 3);
    } else if (event is PhoneChanged) {
      yield state.copyWith(isPhoneValid: validateMobile(event.phone) == null);
    } else if (event is OnSelectMarital) {
      yield state.copyWith(maritalStatusSelected: event.maritalStatus);
    } else if (event is PasswordChanged) {
      yield state.copyWith(
          hasUppercase: Utils.isPasswordUppercase(event.password),
          hasDigits: Utils.isPasswordDigits(event.password),
          hasSpecialCharacters:
              Utils.isPasswordSpecialCharacters(event.password),
          hasSpaceCharacters:
              Utils.isPasswordHasSpaceCharacters(event.password),
          hasMinLength: Utils.isPasswordMinLength(event.password),
          isPasswordValid: Utils.isPasswordCompliant(event.password));
    } else if (event is ConfirmPasswordChanged) {
      yield state.copyWith(
          isPasswordMatched: event.password == event.confirmPassword);
    } else if (event is RegisterButtonPressed) {
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
    } else if (event is DoCountDown) {
      yield state.countDown();
    } else if (event is DoBackRoute) {
      switch (state.currentRoute) {
        case RegisterRoute.enterPinCode:
          yield state.copyWith(
              currentRoute: RegisterRoute.enterInformationForm);
          break;
        case RegisterRoute.enterInformationForm:
        default:
          yield state.copyWith(currentRoute: RegisterRoute.popBack);
      }
    } else if (event is StartCountDown) {
      await streamController?.cancel();
      streamController =
          Stream<int>.periodic(const Duration(seconds: 1), (x) => 1)
              .take(totalTimeCount)
              .listen((value) => add(DoCountDown()));
    } else if (event is DoResendCode) {
      final result = await userRepository.resendVerifyCode(state.email);
      yield result.fold(
          (l) => state.verifyCodeFailData(
              registerStatus: RegisterStatus.verifyCodeFail,
              mess: (l as RemoteDataFailure).errorMessage),
          (r) => state.copyWith(
              tokenCode: r,
              timeResend: totalTimeCount,
              currentRoute: RegisterRoute.enterPinCode));
      add(StartCountDown());
    } else if (event is InformationButtonPressed) {
      // yield state.copyWith(currentRoute: RegisterRoute.enterRegisterForm);
    } else if (event is SubmitVerifyCode) {
      final result =
          await userRepository.doActivateAccount(event.code, state.tokenCode);
      yield result.fold(
          (l) => state.verifyCodeFailData(
              registerStatus: RegisterStatus.verifyCodeFail,
              mess: (l as RemoteDataFailure).errorMessage), (r) {
        streamController?.cancel();
        return state.submitResult(status: RegisterStatus.registerSuccess);
      });

      add(DoLogin(result.getOrElse(null)));
    } else if (event is DoLogin) {
      final result = await userRepository.getMe(accessToken: event.accessToken);
      yield result.fold(
          (l) => state.verifyCodeFailData(
              registerStatus: RegisterStatus.verifyCodeFail,
              mess: (l as RemoteDataFailure).errorMessage), (r) {
        return state.submitResult(
            status: RegisterStatus.getProfileSuccess, userInfo: r);
      });
    } else if (event is LoadCountryCode) {
      final result = await configRepository.getCountryCode();
      yield* _handleGetCountryCodeResult(result);
    } else if (event is OnSelectCountryCode) {
      yield state.copyWith(selectedCountry: event.countryStatus);
    }
  }

  Stream<RegisterState> _handleRegisterResult(
      Either<Failure, RegisterInfo> result, String email) async* {
    yield result
        .fold((failure) => state.submitResult(status: RegisterStatus.failed),
            (right) {
      if (right.tokenCode != null) {
        add(StartCountDown());
        return state.copyWith(
            email: email,
            tokenCode: right.tokenCode,
            currentRoute: RegisterRoute.enterPinCode);
      }
      if (right.accessToken != null) {
        add(DoLogin(right.accessToken));
        return state.submitResult(status: RegisterStatus.registerSuccess);
      }
      return state.submitResult(status: RegisterStatus.alreadyRegister);
    });
  }

  @override
  void onTransition(Transition<RegisterEvent, RegisterState> transition) {
    super.onTransition(transition);
  }

  Stream<RegisterState> _handleGetCountryCodeResult(
      Either<Failure, List<Country>> result) async* {
    yield result.fold(
      (failure) => state,
      (country) {
        return state.copyWith(
            listCountry: country, selectedCountry: country[0]);
      },
    );
  }
}

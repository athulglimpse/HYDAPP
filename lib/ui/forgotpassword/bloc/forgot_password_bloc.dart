import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../utils/utils.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  static const totalTimeCount = 30;
  final UserRepository userRepository;
  StreamSubscription<int> streamController;

  ForgotPasswordBloc({this.userRepository})
      : super(ForgotPasswordState.initial(totalTimeCount));

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is DoCountDown) {
      yield state.countDown();
    } else if (event is DoBackRoute) {
      switch (state.currentRoute) {
        case ForgotPasswordRoute.enterPinCode:
          yield state.copyWith(currentRoute: ForgotPasswordRoute.enterEmail);
          break;
        case ForgotPasswordRoute.enterNewPassword:
          yield state.copyWith(
              currentRoute: ForgotPasswordRoute.enterPinCode, timeResend: 0);
          break;
        case ForgotPasswordRoute.enterEmail:
        default:
          yield state.copyWith(currentRoute: ForgotPasswordRoute.popBack);
      }
    } else if (event is StartCountDown) {
      await streamController?.cancel();
      streamController =
          Stream<int>.periodic(const Duration(seconds: 1), (x) => 1)
              .take(totalTimeCount)
              .listen((value) => add(DoCountDown()));
    } else if (event is SubmitEmailToVerify) {
      final result =
          await userRepository.submitEmailForgotPassword(event.email);
      yield result.fold(
          (l) => state.copyWith(
                mess: (l as RemoteDataFailure).errorMessage,
                forgotPasswordStatus: ForgotPasswordStatus.emailInvalid,
              ),
          (r) => state.copyWith(
              timeResend: totalTimeCount,
              email: event.email,
              tokenCode: r.tokenCode,
              currentRoute: ForgotPasswordRoute.enterPinCode));
      add(StartCountDown());
    } else if (event is DoResendCode) {
      final result =
          await userRepository.submitEmailForgotPassword(state.email);
      yield result.fold(
          (l) => state.copyWith(
              forgotPasswordStatus: ForgotPasswordStatus.emailInvalid,
              mess: (l as RemoteDataFailure).errorMessage),
          (r) => state.copyWith(
              timeResend: totalTimeCount,
              tokenCode: r.tokenCode,
              currentRoute: ForgotPasswordRoute.enterPinCode));
      add(StartCountDown());
    } else if (event is SubmitVerifyCode) {
      final result = await userRepository.doVerifyCodeForgotPassword(
          event.code, event.tokenCode);
      yield result.fold(
          (l) => state.copyWith(
              forgotPasswordStatus: ForgotPasswordStatus.verifyCodeInvalid,
              mess: (l as RemoteDataFailure).errorMessage), (r) {
        streamController?.cancel();
        return state.copyWith(
            timeResend: totalTimeCount,
            tokenCode: r.tokenCode,
            currentRoute: ForgotPasswordRoute.enterNewPassword);
      });
    } else if (event is SubmitNewPassword) {
      final result = await userRepository.createNewPassword(
          event.newPassword, event.confirmNewPassword, event.tokenCode);
      yield result.fold(
          (l) => state.copyWith(
              forgotPasswordStatus: ForgotPasswordStatus.newPasswordInvalid,
              mess: (l as RemoteDataFailure).errorMessage), (r) {
        return state.copyWith(
            timeResend: totalTimeCount,
            forgotPasswordStatus: ForgotPasswordStatus.changePasswordSuccess,
            currentRoute: ForgotPasswordRoute.enterNewPassword);
      });
    } else if (event is PasswordChanged) {
      yield state.copyWith(
          hasUppercase: Utils.isPasswordUppercase(event.password),
          hasDigits: Utils.isPasswordDigits(event.password),
          hasSpecialCharacters:
              Utils.isPasswordSpecialCharacters(event.password),
          hasMinLength: Utils.isPasswordMinLength(event.password),
          isPasswordValid: Utils.isPasswordCompliant(event.password));
    } else if (event is ConfirmPasswordChanged) {
      yield state.copyWith(
          isPasswordMatched: event.password == event.confirmPassword);
    }
  }
}

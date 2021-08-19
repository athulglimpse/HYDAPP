import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_info.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';

part 'verify_code_event.dart';
part 'verify_code_state.dart';

class VerifyCodeBloc extends Bloc<VerifyCodeEvent, VerifyCodeState> {
  static const totalTimeCount = 30;
  final UserRepository userRepository;
  StreamSubscription<int> streamController;

  VerifyCodeBloc({this.userRepository})
      : super(VerifyCodeState.initial(
          timeResendInit: totalTimeCount,
          email: userRepository.getCurrentUser()?.email,
          userInfo: userRepository.getCurrentUser(),
        ));

  @override
  Stream<VerifyCodeState> mapEventToState(
    VerifyCodeEvent event,
  ) async* {
    if (event is StoreEmail) {
      yield state.copyWith(email: event.email, tokenCode: event.tokenCode);
    } else if (event is ClearUserAndBackToStartedScreen) {
      await userRepository.logout();
      yield state.copyWith(isLogout: true);
    } else if (event is ResendCode) {
      final result = await userRepository.resendVerifyCode(state.email);

      yield result.fold(
          (l) => state.failVerifyCode(
              errMessage: (l as RemoteDataFailure).errorMessage),
          (r) => state.copyWith(tokenCode: r, timeResend: totalTimeCount));
      add(StartCountDown());
    } else if (event is SubmitVerifyCode) {
      await streamController?.cancel();
      final result =
          await userRepository.doActivateAccount(event.code, state.tokenCode);

      // ignore: prefer_typing_uninitialized_variables
      var resultUserInfo;

      ///Update user Info if user has been login
      if (result.isRight() && state.userInfo != null) {
        resultUserInfo = await userRepository.getMe();
      }
      yield result.fold(
          (l) => state.failVerifyCode(
              errMessage: (l as RemoteDataFailure).errorMessage),
          (r) => state.copyWith(
              verifyCodeStatus: VerifyCodeStatus.success,
              userInfo: resultUserInfo.getOrElse(null)));
    } else if (event is DoCountDown) {
      yield state.countDown();
    } else if (event is StartCountDown) {
      await streamController?.cancel();
      streamController =
          Stream<int>.periodic(const Duration(seconds: 1), (x) => 1)
              .take(totalTimeCount)
              .listen((value) => add(DoCountDown()));
    }
  }
}

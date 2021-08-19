import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import '../../../utils/ui_util.dart';
import '../../../utils/utils.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository userRepository;
  ChangePasswordBloc({this.userRepository}) : super(CheckOldPasswordState());

  @override
  Stream<ChangePasswordState> mapEventToState(
    ChangePasswordEvent event,
  ) async* {
    switch (event.runtimeType) {
      case BackRoute:
        yield CheckOldPasswordState();
        break;
      case CheckOldPassword:
        yield* _checkOldPass(event);
        break;
      case PasswordChanged:
        yield* _checkPass(event);
        break;
      case ConfirmPasswordChanged:
        yield* _checkConfirmPassword(event);
        break;
      case SubmitNewPassword:
        yield* _changeNewPass(event);
        break;
    }
  }

  Stream<ChangePasswordState> _checkConfirmPassword(
      ConfirmPasswordChanged event) async* {
    yield state.copyWith(
        isPasswordMatched: event.password == event.confirmPassword);
  }

  Stream<ChangePasswordState> _checkPass(PasswordChanged event) async* {
    yield state.copyWith(
        hasUppercase: Utils.isPasswordUppercase(event.password),
        hasDigits: Utils.isPasswordDigits(event.password),
        hasSpecialCharacters: Utils.isPasswordSpecialCharacters(event.password),
        hasMinLength: Utils.isPasswordMinLength(event.password),
        isPasswordValid: Utils.isPasswordCompliant(event.password));
  }

  Stream<ChangePasswordState> _checkOldPass(CheckOldPassword event) async* {
    final data = await userRepository.doCheckOldPassword(event.oldPass);
    yield data.fold((l) {
      UIUtil.showToast(
        (l as RemoteDataFailure).errorMessage,
        backgroundColor: Colors.red,
      );
      return CheckOldPasswordState();
    },
        (r) => ChangePasswordState(
            tokenCode: r, status: ChangePassStatus.CHECK_PASSWORD_SUCCESS));
  }

  Stream<ChangePasswordState> _changeNewPass(SubmitNewPassword event) async* {
    final data =
        await userRepository.changePassword(event.tokenCode, event.newPass);
    yield data.fold((l) {
      UIUtil.showToast(
        (l as RemoteDataFailure).errorMessage,
        backgroundColor: Colors.red,
      );
      return state.copyWith(status: ChangePassStatus.FAIL);
    }, (r) => state.copyWith(status: ChangePassStatus.CHANGE_PASSWORD_SUCCESS));
  }
}

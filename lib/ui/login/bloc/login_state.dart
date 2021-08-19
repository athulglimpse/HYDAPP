import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_info.dart';

@immutable
class LoginState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool ableToLogin;
  final LoginStatus loginStatus;
  final String socialId;
  final String email;
  final String socialMethod;
  final String errorMessage;
  final String tokenState;
  final UserInfo userInfo;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    this.ableToLogin = false,
    this.loginStatus,
    this.socialId,
    this.tokenState,
    this.email,
    this.socialMethod,
    this.errorMessage,
    this.userInfo,
  });

  factory LoginState.initial() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      ableToLogin: false,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    String email,
    UserInfo userInfo,
    String errorMessage,
    String socialId,
    String tokenState,
    String socialMethod,
    LoginStatus loginStatus,
    bool isPasswordValid,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      userInfo: userInfo ?? this.userInfo,
      email: email ?? this.email,
      socialId: socialId ?? this.socialId,
      tokenState: tokenState ?? this.tokenState,
      socialMethod: socialMethod ?? this.socialMethod,
      errorMessage: errorMessage,
      loginStatus: loginStatus,
      ableToLogin: isLoginAble(isEmailValid ?? this.isEmailValid,
          isPasswordValid ?? this.isPasswordValid),
    );
  }

  bool isLoginAble(bool isEmailValid, bool isPassValid) {
    return isEmailValid && isPassValid;
  }

  LoginState submitResult({
    LoginStatus status,
    UserInfo userInfo,
    String errorMessage,
    String email,
    String tokenState,
    String socialId,
    String socialMethod,
  }) {
    return copyWith(
        loginStatus: status,
        userInfo: userInfo,
        errorMessage: errorMessage,
        email: email,
        tokenState: tokenState,
        socialId: socialId,
        socialMethod: socialMethod);
  }

  @override
  List<Object> get props => [
        isEmailValid,
        isPasswordValid,
        ableToLogin,
        tokenState,
        errorMessage,
        socialId,
        loginStatus,
        email
      ];

  @override
  String toString() {
    return '''MyFormState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      loginStatus: $loginStatus,
      errorMessage: $errorMessage,
      tokenState: $tokenState,
      email: $email,
      socialId: $socialId,
      isAbleToLogin: $ableToLogin,
    }''';
  }
}

enum LoginStatus {
  notVerified,
  notChoosePersonalization,
  success,
  linkAccount,
  loginSocial,
  wrongCredential,
  failed,
}

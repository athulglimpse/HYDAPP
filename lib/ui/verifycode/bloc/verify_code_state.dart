part of 'verify_code_bloc.dart';

@immutable
class VerifyCodeState extends Equatable {
  final String tokenCode;
  final int timeResend;
  final UserInfo userInfo;
  final bool isLogout;
  final String errMessage;
  final VerifyCodeStatus verifyCodeStatus;
  final String email;

  VerifyCodeState({
    this.tokenCode,
    this.timeResend,
    this.userInfo,
    this.isLogout,
    this.verifyCodeStatus,
    this.errMessage,
    this.email,
  });

  factory VerifyCodeState.initial(
      {String email, int timeResendInit, UserInfo userInfo}) {
    return VerifyCodeState(
        email: email, timeResend: timeResendInit, userInfo: userInfo);
  }
  VerifyCodeState countDown() {
    return copyWith(timeResend: max(0, timeResend - 1));
  }

  VerifyCodeState copyWith({
    String tokenCode,
    int timeResend,
    UserInfo userInfo,
    String errMessage,
    bool isLogout,
    String email,
    VerifyCodeStatus verifyCodeStatus,
  }) {
    return VerifyCodeState(
      tokenCode: tokenCode ?? this.tokenCode,
      timeResend: timeResend ?? this.timeResend,
      isLogout: isLogout ?? false,
      userInfo: userInfo ?? this.userInfo,
      verifyCodeStatus: verifyCodeStatus,
      errMessage: errMessage,
      email: email ?? this.email,
    );
  }

  VerifyCodeState failVerifyCode({String errMessage}) {
    return copyWith(
      timeResend: timeResend,
      errMessage: errMessage,
      verifyCodeStatus: VerifyCodeStatus.verifyCodeFail,
    );
  }

  @override
  List<Object> get props =>
      [tokenCode, timeResend, errMessage, email, verifyCodeStatus, isLogout];

  @override
  String toString() {
    return '''MyFormState {
      tokenCode: $tokenCode,
      isLogout: $isLogout,
      verifyCodeStatus: $verifyCodeStatus,
      timeResend: $timeResend,
      errMessage: $errMessage,
      email: $email,
    }''';
  }
}

enum VerifyCodeStatus { success, failed, verifyCodeFail }

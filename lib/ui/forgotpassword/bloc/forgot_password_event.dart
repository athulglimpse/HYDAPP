part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class DoCountDown extends ForgotPasswordEvent {}

class StartCountDown extends ForgotPasswordEvent {}

class DoResendCode extends ForgotPasswordEvent {}

class PasswordChanged extends ForgotPasswordEvent {
  final String password;

  PasswordChanged({@required this.password});

  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends ForgotPasswordEvent {
  final String confirmPassword;
  final String password;

  ConfirmPasswordChanged(
      {@required this.password, @required this.confirmPassword});

  List<Object> get props => [confirmPassword, password];
}

class SubmitEmailToVerify extends ForgotPasswordEvent {
  final String email;
  SubmitEmailToVerify({this.email});
}

class SubmitVerifyCode extends ForgotPasswordEvent {
  final String code;
  final String tokenCode;
  SubmitVerifyCode({this.code, this.tokenCode});
}

class SubmitNewPassword extends ForgotPasswordEvent {
  final String newPassword;
  final String confirmNewPassword;
  final String tokenCode;

  SubmitNewPassword({
    this.newPassword,
    this.confirmNewPassword,
    this.tokenCode,
  });
}

class DoBackRoute extends ForgotPasswordEvent {}

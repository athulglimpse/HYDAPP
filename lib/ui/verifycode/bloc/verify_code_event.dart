part of 'verify_code_bloc.dart';

@immutable
abstract class VerifyCodeEvent {}

class StoreEmail extends VerifyCodeEvent {
  final String email;
  final String tokenCode;

  StoreEmail(this.email, this.tokenCode);
}

class ClearUserAndBackToStartedScreen extends VerifyCodeEvent {}

class ResendCode extends VerifyCodeEvent {}

class DoCountDown extends VerifyCodeEvent {}

class StartCountDown extends VerifyCodeEvent {}

class SubmitVerifyCode extends VerifyCodeEvent {
  final String code;

  SubmitVerifyCode(this.code);
}

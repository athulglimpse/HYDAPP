part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent {}

class BackRoute extends ChangePasswordEvent {

}

class CheckOldPassword extends ChangePasswordEvent {
  final String oldPass;

  CheckOldPassword({this.oldPass});
}

class SubmitNewPassword extends ChangePasswordEvent {
  final String newPass;
  final String tokenCode;

  SubmitNewPassword({this.newPass, this.tokenCode});
}

class PasswordChanged extends ChangePasswordEvent {
  final String password;

  PasswordChanged({@required this.password});

  List<Object> get props => [password];
}

class ConfirmPasswordChanged extends ChangePasswordEvent {
  final String confirmPassword;
  final String password;

  ConfirmPasswordChanged(
      {@required this.password, @required this.confirmPassword});

  List<Object> get props => [confirmPassword, password];
}

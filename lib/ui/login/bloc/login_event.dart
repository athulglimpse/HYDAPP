import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSocial extends LoginEvent {
  final String socialId;
  final String email;
  final String type;

  LoginSocial({this.socialId, this.email, this.type});
}

class LinkAccount extends LoginEvent {
  final String password;

  LinkAccount(this.password);
}

class EmailChanged extends LoginEvent {
  final String email;
  const EmailChanged({@required this.email});
  @override
  List<Object> get props => [email];
  @override
  String toString() => 'EmailChanged { email: $email }';
}

class EmailFailed extends LoginEvent {
  final String email;
  EmailFailed(this.email);
}

class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  const LoginButtonPressed({
    @required this.username,
    @required this.password,
  });

  @override
  List<Object> get props => [username, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $username, password: $password }';
}

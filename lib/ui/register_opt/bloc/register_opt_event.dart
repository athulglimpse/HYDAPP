import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterOptEvent extends Equatable {
  const RegisterOptEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterOptEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class EmailFailed extends RegisterOptEvent {
  final String email;

  EmailFailed(this.email);
}

class PasswordChanged extends RegisterOptEvent {
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class LoadCountryCode extends RegisterOptEvent {}

class DoLogin extends RegisterOptEvent {
  final String accessToken;

  DoLogin(this.accessToken);
}

class RegisterByEmail extends RegisterOptEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dialCode;
  final String dob;
  final String maritalId;
  final String type;
  final String socialId;
  final int hasSocialEmail;
  final String password;

  const RegisterByEmail(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.dob,
      @required this.socialId,
      @required this.hasSocialEmail,
      @required this.maritalId,
      @required this.type,
      @required this.dialCode,
      this.phone,
      this.password});

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        phone,
        dialCode,
        dob,
        maritalId,
        type,
        socialId,
        hasSocialEmail,
        password
      ];

  @override
  String toString() =>
      'RegisterByEmail { username: $firstName, password: $password }';
}

class LoginButtonPressed extends RegisterOptEvent {
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

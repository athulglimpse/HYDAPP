part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class Logged extends SplashState {
  final UserInfo userInfo;

  Logged(this.userInfo);
}

class SignedOut extends SplashState {}

class LoadStartedContent extends SplashState {}

part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {}

class CheckUserLogin extends SplashEvent {}

class FetchConfig extends SplashEvent {}

class FetchOnlyConfig extends SplashEvent {}

class FetchInterestedContent extends SplashEvent {}

class FetchStaticContent extends SplashEvent {}

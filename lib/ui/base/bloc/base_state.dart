part of 'base_bloc.dart';

@immutable
abstract class BaseBlocState {
  final UserInfo userInfo;

  BaseBlocState({this.userInfo});
}

class AppLink extends BaseBlocState {
  final Uri uri;
  AppLink({this.uri, UserInfo userInfo}) : super(userInfo: userInfo);
}

class BaseInitial extends BaseBlocState {
  BaseInitial({UserInfo userInfo}) : super(userInfo: userInfo);
}

class UpdateProfile extends BaseBlocState {
  UpdateProfile({UserInfo userInfo}) : super(userInfo: userInfo);
}

class LogoutState extends BaseBlocState {}

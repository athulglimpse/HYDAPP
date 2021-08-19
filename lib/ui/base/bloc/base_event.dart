part of 'base_bloc.dart';

@immutable
abstract class BaseEvent {}

class Logout extends BaseEvent {}

class Init extends BaseEvent {}

class FetchUserProfile extends BaseEvent {}

class OnAppLink extends BaseEvent {
  final Uri uri;

  OnAppLink({
    this.uri,
  });
}

class OnProfileChange extends BaseEvent {}

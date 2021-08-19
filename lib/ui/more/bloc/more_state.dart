part of 'more_bloc.dart';

@immutable
class MoreState extends Equatable {
  final UserInfo userInfo;
  MoreState({this.userInfo});

  factory MoreState.init(UserRepository userRepository) {
    return MoreState(userInfo: userRepository.getCurrentUser());
  }

  MoreState copyWith({
    UserInfo userInfo,
  }) {
    return MoreState(
      userInfo: userInfo ?? this.userInfo,
    );
  }

  @override
  List<Object> get props => [userInfo];
}

class LogoutSuccess extends MoreState {}

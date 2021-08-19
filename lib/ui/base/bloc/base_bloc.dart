import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_info.dart';
import '../../../data/repository/user_repository.dart';
import '../../../utils/utils.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseBlocState> {
  final UserRepository userRepository;
  BaseBloc({this.userRepository})
      : super(BaseInitial(userInfo: userRepository.getCurrentUser()));

  @override
  Stream<BaseBlocState> mapEventToState(
    BaseEvent event,
  ) async* {
    if (!(state is LogoutState) && event is Logout) {
      await userRepository.logout();
      yield LogoutState();
    } else if (event is OnAppLink) {
      yield AppLink(
          uri: event.uri,
          userInfo: state?.userInfo ?? userRepository.getCurrentUser());
    } else if (event is OnProfileChange) {
      yield UpdateProfile(userInfo: userRepository.getCurrentUser());
    } else if (event is Init) {
      yield BaseInitial(
          userInfo: state?.userInfo ?? userRepository.getCurrentUser());
    } else if (event is FetchUserProfile) {
      final deviceToken = await Utils.getDeviceToken();
      final deviceId = await Utils.getDeviceDetails();
      if (state?.userInfo != null && state.userInfo.isUser()) {
        await userRepository.updateDeviceToken(deviceId, deviceToken);
      }
      final result = await userRepository.getMe();
      yield result.fold((l) => state,
          (r) => UpdateProfile(userInfo: userRepository.getCurrentUser()));
    }
  }
}

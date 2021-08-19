import 'package:equatable/equatable.dart';

import '../../../data/model/user_community_model.dart';
import '../../../data/model/user_info.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../data/repository/user_repository.dart';

class MyCommunityState extends Equatable {
  final List<UserCommunityModel> listUserCommunityModel;
  final UserInfo userInfo;
  final String refreshTime;

  MyCommunityState({
    this.listUserCommunityModel,
    this.userInfo,
    this.refreshTime,
  });

  factory MyCommunityState.initial(
      ProfileRepository profileRepository, UserRepository userRepository) {
    final userInfo = userRepository.getCurrentUser();
    return MyCommunityState(
      userInfo: userRepository.getCurrentUser(),
      listUserCommunityModel:
          profileRepository.getListMyCommunity(userInfo?.email ?? ''),
    );
  }

  MyCommunityState copyWith({
    List<UserCommunityModel> listUserCommunityModel,
    UserInfo userInfo,
    String refreshTime,
  }) {
    return MyCommunityState(
      listUserCommunityModel:
          listUserCommunityModel ?? this.listUserCommunityModel,
      userInfo: userInfo ?? this.userInfo,
      refreshTime: refreshTime ?? this.refreshTime,
    );
  }

  @override
  List<Object> get props => [
        listUserCommunityModel,
    refreshTime,
        userInfo,
      ];

  @override
  String toString() {
    return '''MyFormState {
    listUserCommunityModel:$listUserCommunityModel,
    userInfo:$userInfo,
    }''';
  }
}

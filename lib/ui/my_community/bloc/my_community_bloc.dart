import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/user_community_model.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../data/source/failure.dart';
import 'my_community_event.dart';
import 'my_community_state.dart';

class MyCommunityBloc extends Bloc<MyCommunityEvent, MyCommunityState> {
  final ProfileRepository profileRepository;
  final UserRepository userRepository;

  MyCommunityBloc(
      {@required this.profileRepository, @required this.userRepository})
      : super(MyCommunityState.initial(profileRepository, userRepository));

  @override
  Stream<MyCommunityState> mapEventToState(MyCommunityEvent event) async* {
    if (event is FetchMyCommunity) {
      final result =
          await profileRepository.fetchMyCommunity(state.userInfo.email);
      yield* _handleGetMyCommunityResult(result);
    }
  }

  Stream<MyCommunityState> _handleGetMyCommunityResult(
      Either<Failure, List<UserCommunityModel>> result) async* {
    yield result.fold(
      (failure) =>
          state.copyWith(refreshTime: DateTime.now().toIso8601String()),
      (value) {
        return state.copyWith(
            listUserCommunityModel: value,
            refreshTime: DateTime.now().toIso8601String());
      },
    );
  }
}

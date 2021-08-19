import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user_info.dart';
import '../../../data/repository/user_repository.dart';

part 'more_event.dart';
part 'more_state.dart';

class MoreBloc extends Bloc<MoreEvent, MoreState> {
  final UserRepository userRepository;
  MoreBloc({this.userRepository}) : super(MoreState.init(userRepository));

  @override
  Stream<MoreState> mapEventToState(
    MoreEvent event,
  ) async* {
    if (event is Logout) {
      await userRepository.logout();
      yield LogoutSuccess();
    }
  }
}

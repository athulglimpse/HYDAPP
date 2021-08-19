import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState.initial());

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is OnTabHome) {
      print('OnTabHome');
      yield state.copyWith(currentTab: TAB_HOME);
    } else if (event is OnTabEvent) {
      print('OnTabEvent');
      yield state.copyWith(currentTab: TAB_EVENT);
    } else if (event is OnTabMap) {
      print('OnTabMap');
      yield state.copyWith(currentTab: TAB_MAP);
    } else if (event is OnTabSetting) {
      yield state.copyWith(currentTab: TAB_SETTING);
    }
  }

  @override
  void onTransition(Transition<MainEvent, MainState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/activity_model.dart';
import '../../../../data/repository/home_repository.dart';

part 'weekend_activity_see_all_event.dart';
part 'weekend_activity_see_all_state.dart';

class WeekendActivitySeeAllBloc
    extends Bloc<WeekendActivitySeeAllEvent, WeekendActivitySeeAllState> {
  final HomeRepository homeRepository;
  WeekendActivitySeeAllBloc({this.homeRepository})
      : super(WeekendActivitySeeAllState.initial(homeRepository));

  @override
  Stream<WeekendActivitySeeAllState> mapEventToState(
    WeekendActivitySeeAllEvent event,
  ) async* {
    if (event is FetchActivities) {
      final result = await homeRepository.fetchListWeekendActivities(
          experienceId: event.experience.toString());
      yield result.fold((l) => state,
          (r) => state.copyWith(items: r, experience: event.experience));
    }
  }
}

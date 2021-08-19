part of 'weekend_activity_see_all_bloc.dart';

@immutable
class WeekendActivitySeeAllState extends Equatable {
  final List<ActivityModel> items;
  final int experience;

  WeekendActivitySeeAllState({this.items, this.experience});

  factory WeekendActivitySeeAllState.initial(HomeRepository homeRepository) {
    return WeekendActivitySeeAllState(
        items: homeRepository.getActivities(), experience: 0);
  }

  WeekendActivitySeeAllState copyWith({
    List<ActivityModel> items,
    int experience,
  }) {
    return WeekendActivitySeeAllState(
      items: items ?? this.items,
      experience: experience ?? this.experience,
    );
  }

  @override
  List<Object> get props => [
        items,
        experience,
      ];
}

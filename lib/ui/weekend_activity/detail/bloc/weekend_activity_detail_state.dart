part of 'weekend_activity_detail_bloc.dart';

@immutable
class WeekendActivityDetailState extends Equatable {
  final ActivityModel activityModel;
  final String timeRefresh;
  final List<ActivityModel> activitiesAlsoLike;
  final List<CommunityPost> listCommunities;

  WeekendActivityDetailState({
    this.activityModel,
    this.listCommunities,
    this.activitiesAlsoLike,
    this.timeRefresh,
  });

  factory WeekendActivityDetailState.initial(
      ActivityRepository amenityRepository, HomeRepository homeRepository) {
    // final communityModel = homeRepository.getCommunityListInfo();
    return WeekendActivityDetailState(listCommunities: null);
  }

  WeekendActivityDetailState copyWith({
    ActivityModel activityModel,
    String timeRefresh,
    List<CommunityPost> listCommunities,
    List<ActivityModel> activitiesAlsoLike,
  }) {
    return WeekendActivityDetailState(
        activityModel: activityModel ?? this.activityModel,
        listCommunities: listCommunities ?? this.listCommunities,
        timeRefresh: timeRefresh ?? this.timeRefresh,
        activitiesAlsoLike: activitiesAlsoLike ?? this.activitiesAlsoLike);
  }

  @override
  List<Object> get props =>
      [activityModel, activitiesAlsoLike, listCommunities, timeRefresh];
}

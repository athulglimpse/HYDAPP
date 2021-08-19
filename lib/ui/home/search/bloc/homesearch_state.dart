part of 'homesearch_bloc.dart';

abstract class HomeSearchState extends Equatable {
  final int experienceId;
  final List<RecentModel> recentModels;
  final List<RecentModel> recentTodayModels;
  final List<RecentModel> recentYesModels;
  HomeSearchState({
    this.experienceId,
    this.recentTodayModels,
    this.recentYesModels,
    this.recentModels,
  });

  @override
  List<Object> get props => [
        experienceId,
        recentModels,
        recentTodayModels,
        recentYesModels,
      ];
}

class HomeSearchInitial extends HomeSearchState {}

class HomeSearchDisplayed extends HomeSearchState {
  final bool isFocusFieldSearch;
  final List<PlaceModel> listTrending;

  HomeSearchDisplayed({
    @required this.isFocusFieldSearch,
    @required this.listTrending,
    @required int experienceId,
    recentModels,
    recentTodayModels,
    recentYesModels,
  }) : super(
          experienceId: experienceId,
          recentModels: recentModels,
          recentTodayModels: recentTodayModels,
          recentYesModels: recentYesModels,
        );

  @override
  List<Object> get props => [isFocusFieldSearch, listTrending, ...super.props];
}

class GetSearchRecentEventSuccess extends HomeSearchDisplayed {
  GetSearchRecentEventSuccess({
    recentModels,
    recentTodayModels,
    recentYesModels,
    bool isFocusFieldSearch,
    List<PlaceModel> listTrending,
    int experienceId,
  }) : super(
            isFocusFieldSearch: isFocusFieldSearch,
            listTrending: listTrending,
            experienceId: experienceId,
            recentTodayModels: recentTodayModels,
            recentYesModels: recentYesModels,
            recentModels: recentModels);

  @override
  List<Object> get props => [recentModels, ...super.props];
}

class Searching extends GetSearchRecentEventSuccess {
  Searching({
    recentModels,
    recentTodayModels,
    recentYesModels,
    int experienceId,
  }) : super(
          experienceId: experienceId,
          recentModels: recentModels,
          recentTodayModels: recentTodayModels,
          recentYesModels: recentYesModels,
        );

  @override
  List<Object> get props => [...super.props];
}

class HomeSearchSuccess extends GetSearchRecentEventSuccess {
  final List<EventInfo> events;
  final String keyword;
  final List<PlaceModel> amenities;

  HomeSearchSuccess({
    @required this.events,
    @required this.keyword,
    @required this.amenities,
    recentModels,
    recentTodayModels,
    recentYesModels,
    int experienceId,
  }) : super(
          experienceId: experienceId,
          recentModels: recentModels,
          recentTodayModels: recentTodayModels,
          recentYesModels: recentYesModels,
        );

  @override
  List<Object> get props => [events, keyword, amenities, ...super.props];
}

class HomeSearchError extends GetSearchRecentEventSuccess {
  final String msg;

  HomeSearchError(this.msg);
}

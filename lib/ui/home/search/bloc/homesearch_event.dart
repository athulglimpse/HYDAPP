part of 'homesearch_bloc.dart';

abstract class HomeSearchEvent extends Equatable {
  final int experienceId;
  const HomeSearchEvent({this.experienceId});

  @override
  List<Object> get props => [experienceId];
}

class FocusFieldSearchEvent extends HomeSearchEvent {
  final bool isFocusFieldSearch;
  final List<PlaceModel> listTrending;

  FocusFieldSearchEvent(this.isFocusFieldSearch, this.listTrending,
      {int experienceId})
      : super(experienceId: experienceId);
}

class SelectExperienceSearch extends HomeSearchEvent {
  SelectExperienceSearch({int experienceId})
      : super(experienceId: experienceId);
}

class GetSearchRecentEvent extends HomeSearchEvent {
  GetSearchRecentEvent({int experienceId}) : super(experienceId: experienceId);
}

class SearchkeyWordEvent extends HomeSearchEvent {
  final String keyword;

  SearchkeyWordEvent({this.keyword, int experienceId})
      : super(experienceId: experienceId);

  @override
  List<Object> get props => [keyword];
}

class ClearSearchEvent extends HomeSearchEvent {}

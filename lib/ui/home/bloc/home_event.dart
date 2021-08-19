part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchAllData extends HomeEvent {}

class FetchListEvents extends HomeEvent {}

class FetchListCommunity extends HomeEvent {}

class EstimateDistance extends HomeEvent {
  final ViewAssetType viewAssetType;

  EstimateDistance({this.viewAssetType});
}

class AddPostFavorite extends HomeEvent {
  final CommunityPost communityPost;

  AddPostFavorite(this.communityPost);
}

class FetchNearBy extends HomeEvent {
  final double lat; //Latitude
  final double lon; //Longitude

  FetchNearBy(this.lat, this.lon);
}

class FetchWeatherInfo extends HomeEvent {
  final String lat; //Latitude
  final String lon; //Longitude

  FetchWeatherInfo(this.lat, this.lon);
}

class SelectExperience extends HomeEvent {
  final AreaItem areaItem;

  SelectExperience(this.areaItem);
}

class OnApplyFilter extends HomeEvent {
  final Map<int, Map> filterOptSelected;
  OnApplyFilter(this.filterOptSelected);
}

class SelectFacility extends HomeEvent {
  SelectFacility();
}

class EnterDetail extends HomeEvent {
  final AreaItem areaItem;

  EnterDetail(this.areaItem);
}

class DoLogout extends HomeEvent {}

class RemoveEvent extends HomeEvent {
  final String id;

  RemoveEvent(this.id);
}

class TurnOffEvent extends HomeEvent {
  final String id;

  TurnOffEvent(this.id);
}

class EnterHomePage extends HomeEvent {
  EnterHomePage();
}

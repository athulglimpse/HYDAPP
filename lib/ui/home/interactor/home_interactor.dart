import 'package:dartz/dartz.dart';
import 'package:marvista/data/model/activity_model.dart';

import '../../../data/model/area_item.dart';
import '../../../data/model/asset_detail.dart';
import '../../../data/model/community_model.dart';
import '../../../data/model/events.dart';
import '../../../data/model/events_detail.dart';
import '../../../data/model/places_model.dart';
import '../../../data/model/suggestion.dart';
import '../../../data/model/user_info.dart';
import '../../../data/model/weather_info.dart';
import '../../../data/repository/location_repository.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';
import '../../assets/asset_see_all/asset_see_all_grid_page.dart';
import '../bloc/home_bloc.dart';

abstract class HomeInteract {
  Stream<HomeState> estTimeByDistance(
    EstimateDistance event,
    List<PlaceModel> listPlace,
    ViewAssetType viewAssetType,
    HomeState state,
    LocationRepository locationRepository,
  );

  Stream<HomeState> handleWeatherResult(
      Either<Failure, WeatherInfo> result, HomeState state);

  Stream<HomeState> handleAreaItemsResult(
      Either<Failure, List<AreaItem>> result, HomeState state);

  Stream<HomeState> handleSearchResult(
      Either<Failure, Success> searchResult, HomeState state);

  Stream<HomeState> handleEventsResult(
      Either<Failure, List<EventInfo>> result, HomeState state);

  Stream<HomeState> handleSuggestionResult(
      Either<Failure, List<ActivityModel>> result, HomeState state);

  Stream<HomeState> handleCommunityResult(
      Either<Failure, CommunityModel> result, HomeState state);

  Stream<HomeState> handleTrendingByWeekResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleTopRateResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleRestaurantsResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleFacilitiesResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleMightLikeResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);
      
  Stream<HomeState> handleSportsResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleFoodTrucksResult(
      Either<Failure, List<PlaceModel>> result, HomeState state);

  Stream<HomeState> handleEventDetailResult(
      Either<Failure, EventDetailInfo> result, HomeState state);

}

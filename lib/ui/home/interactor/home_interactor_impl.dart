import 'package:dartz/dartz.dart';

import '../../../data/model/activity_model.dart';
import '../../../data/model/area_item.dart';
import '../../../data/model/community_model.dart';
import '../../../data/model/events.dart';
import '../../../data/model/events_detail.dart';
import '../../../data/model/location_model.dart';
import '../../../data/model/places_model.dart';
import '../../../data/model/weather_info.dart';
import '../../../data/repository/location_repository.dart';
import '../../../data/source/api_end_point.dart';
import '../../../data/source/failure.dart';
import '../../../data/source/success.dart';
import '../../../utils/log_utils.dart';
import '../../assets/asset_see_all/asset_see_all_grid_page.dart';
import '../bloc/home_bloc.dart';
import 'home_interactor.dart';

class HomeInteractImpl extends HomeInteract {
  HomeInteractImpl();

  @override
  Stream<HomeState> estTimeByDistance(
      EstimateDistance event,
      List<PlaceModel> listPlace,
      ViewAssetType viewAssetType,
      HomeState state,
      LocationRepository locationRepository) async* {
    // if (event.locationData != null && (listPlace?.isNotEmpty ?? false)) {
    //   final myLocation = LocationModel(
    //     lat: event.locationData.latitude.toString(),
    //     long: event.locationData.longitude.toString(),
    //   );
    //
    //   final listDestination = <String, LocationModel>{};
    //   listPlace.forEach((element) {
    //     if (element.pickOneLocation != null) {
    //       listDestination[element.id.toString()] = element.pickOneLocation;
    //     }
    //   });
    //
    //   final estResult = await locationRepository.estDistanceFromMyLocation(
    //       myLocation, listDestination, TravelMode.walking);
    //   final distanceMatrixModel = estResult.getOrElse(null);
    //   if (estResult.isRight() &&
    //       distanceMatrixModel != null &&
    //       distanceMatrixModel.rows.isNotEmpty &&
    //       distanceMatrixModel.rows[0].elements != null) {
    //     final elements = distanceMatrixModel.rows[0].elements;
    //
    //     for (var i = 0; i < listPlace.length; i++) {
    //       if (i < elements.length) {
    //         listPlace[i].elementsDisMatrix = elements[i];
    //       }
    //     }
    //   }
    //   yield state.copyWith(
    //     timeRefresh: DateTime.now().toIso8601String(),
    //   );
    // } else {
    //   yield state;
    // }
  }

  @override
  Stream<HomeState> handleWeatherResult(
      Either<Failure, WeatherInfo> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(weatherInfo: value),
    );
  }

  @override
  Stream<HomeState> handleAreaItemsResult(
      Either<Failure, List<AreaItem>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (areaItems) => state.copyWith(
          listAreas: areaItems, currentArea: state.currentArea ?? areaItems[0]),
    );
  }

  @override
  Stream<HomeState> handleSearchResult(
      Either<Failure, Success> searchResult, HomeState state) async* {
    yield searchResult.fold(
      (failure) => state,
      (value) => state,
    );
  } 

  @override
  Stream<HomeState> handleEventsResult(
      Either<Failure, List<EventInfo>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }

        return state.copyWith(listEvents: value);
      },
    );
  }

  @override
  Stream<HomeState> handleSuggestionResult(
      Either<Failure, List<ActivityModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(activities: value),
    );
  }

  @override
  Stream<HomeState> handleCommunityResult(
      Either<Failure, CommunityModel> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(communityModel: value),
    );
  }

  @override
  Stream<HomeState> handleTrendingByWeekResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                print('distancvedistancvedistancvedistancve ' +
                    distance.toString());
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }

        return state.copyWith(listTrending: value);
      },
    );
  }

  @override
  Stream<HomeState> handleTopRateResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }

        return state.copyWith(listTopRate: value);
      },
    );
  }

  @override
  Stream<HomeState> handleRestaurantsResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }

        return state.copyWith(listRestaurants: value);
      },
    );
  }

  @override
  Stream<HomeState> handleFacilitiesResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }
        return state.copyWith(listFacilities: value);
      },
    );
  }

  @override
  Stream<HomeState> handleSportsResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }

        return state.copyWith(listActivities: value);
      },
    );
  }

  @override
  Stream<HomeState> handleMightLikeResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }
        print('handleMightLikeResult');
        print(value);
        return state.copyWith(listMightLike: value);
      },
    );
  }

  @override
  Stream<HomeState> handleEventDetailResult(
      Either<Failure, EventDetailInfo> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        return state.copyWith(eventDetailInfo: value);
      },
    );
  }

  @override
  Stream<HomeState> handleFoodTrucksResult(
      Either<Failure, List<PlaceModel>> result, HomeState state) async* {
    yield result.fold(
      (failure) => state,
      (value) {
        try {
          if (state.filterOptSelected != null &&
              state.filterOptSelected.isNotEmpty) {
            state.filterOptSelected.entries.forEach((element) {
              if (element.value.containsKey('key') &&
                  element.value['key'] == PARAM_DISTANCE_RANGE) {
                final distance = element.value['value'];
                value.removeWhere((e) => e.distance >= distance);
              }
            });
          }
        } catch (e) {
          LogUtils.d(e);
        }
        return state.copyWith(listFoodTrucks: value);
      },
    );
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:marvista/utils/app_const.dart';
import 'package:meta/meta.dart';

import '../../../data/model/amenity_model.dart';
import '../../../data/model/area_item.dart';
import '../../../data/model/unity/unity_response_data.dart';
import '../../../data/repository/asset_repository.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/location_repository.dart';

part 'unity_map_event.dart';
part 'unity_map_state.dart';

class UnityMapBloc extends Bloc<UnityMapEvent, UnityMapState> {
  final HomeRepository homeRepository;
  final AssetRepository assetRepository;
  final LocationRepository locationRepository;

  UnityMapBloc(
      {this.homeRepository, this.assetRepository, this.locationRepository})
      : super(UnityMapState.initial(homeRepository));

  @override
  Stream<UnityMapState> mapEventToState(
    UnityMapEvent event,
  ) async* {
    switch (event.runtimeType) {
      case OpenGuideDirection:
        yield* _guideDirection(event);
        break;
      case CloseDirection:
        break;
      case SelectExperience:
        yield* _mapChangeExperienceEvent(event);
        break;
      case LocationChangeEvent:
        yield* _mapSearchEvent(event);
        break;
    }
  }

  Stream<UnityMapState> _guideDirection(OpenGuideDirection event) async* {
    final data = await locationRepository.guideDirection(
        event.locationData,
        double.parse(event.locationResponse.latti),
        double.parse(event.locationResponse.longti));
    yield data.fold((l) => state, (r) {
      try {
        final directionRequest = DirectionRequest();
        final directionModel = r;
        if (directionModel.status?.toLowerCase() == 'ok') {
          directionRequest.id = event.locationResponse.id;
        }
        if (directionModel.routes?.isNotEmpty ?? false) {
          final routes = directionModel.routes[0];
          final listStep = routes.legs[0].steps;
          directionRequest.intro =
              '${listStep[0].htmlInstructions} ${listStep[0].distance.text}';
          directionRequest.latti = listStep[0].endLocation.lat.toString();
          directionRequest.longti = listStep[0].endLocation.lng.toString();

          directionRequest.eta = listStep[0].duration.value.toString();
          if (listStep.length > 1) {
            directionRequest.nextIntro = listStep[1].htmlInstructions;
          }
        }
        return state.copyWith(
          findDirection: true,
          directionRequest: directionRequest,
          selectedLocationId: event.locationResponse.id,
        );
      } catch (e) {
        print('Error' + e.toString());
        return state;
      }
    });
  }

  Stream<UnityMapState> _mapChangeExperienceEvent(
      SelectExperience event) async* {
    final data = await locationRepository.searchNearBy(
      lat: event.lat,
      long: event.long,
      content: event.keyword,
      experience_id: event.areaItem.id,
      distances: event.distance,
    );
    yield data.fold(
        (l) => state,
        (r) => state.copyWith(
              amenities: r,
              currentExperience: event.areaItem,
              needUpdateUnity: true,
            ));
  }

  Stream<UnityMapState> _mapSearchEvent(LocationChangeEvent event) async* {
    final data = await locationRepository.searchNearBy(
      lat: event.lat,
      long: event.long,
      content: event.keyword,
      experience_id: event.experience_id ?? state.currentExperience.id,
      distances: event.distance,
    );
    yield data.fold(
        (l) => state,
        (r) => state.copyWith(
              amenities: r,
              needUpdateUnity: true,
            ));
  }
}

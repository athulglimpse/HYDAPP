import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marvista/data/source/api_end_point.dart';
import 'package:meta/meta.dart';

import '../../../data/model/amenity_model.dart';
import '../../../data/model/area_item.dart';
import '../../../data/repository/asset_repository.dart';
import '../../../data/repository/home_repository.dart';
import '../../../data/repository/location_repository.dart';
import '../../../utils/app_const.dart';
import '../models/place.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  final HomeRepository homeRepository;
  final AssetRepository assetRepository;
  final LocationRepository locationRepository;
  ClusterManager manager;
  final List<ClusterItem<Place>> items = [];

  MapPageBloc({
    @required this.homeRepository,
    @required this.assetRepository,
    @required this.locationRepository,
  }) : super(MapPageState.initial(homeRepository, locationRepository));

  @override
  Stream<MapPageState> mapEventToState(
    MapPageEvent event,
  ) async* {
    switch (event.runtimeType) {
      case UpdateMarker:
        yield* _mapUpdateMarker(event);
        break;
      case UnSelectMarker:
        yield state.clearSelectMarker();
        break;
      case SearchEvent:
        yield* _mapSearchEvent(event);
        break;
      case OnSelectMarker:
        yield* _mapSelectMarker(event);
        break;
    }
  }

  Stream<MapPageState> _mapSelectMarker(OnSelectMarker event) async* {
    yield state.copyWith(
      markerSelected: event.place,
    );
  }

  Stream<MapPageState> _mapUpdateMarker(UpdateMarker event) async* {
    yield state.copyWith(
      markers: event.markers,
    );
  }

  Stream<MapPageState> _mapSearchEvent(SearchEvent event) async* {
    final data = await locationRepository.searchNearBy(
      lat: event.lat,
      long: event.long,
      content: event.keyword,
      experience_id: event.areaItem.id,
      distances: event.distances,
    );

    yield data.fold((l) {
      items.clear();
      manager.setItems(items);
      return state.copyWith(
        amenities: [],
        currentExperience: event.areaItem,
      );
    }, (r) {
      items.clear();
      if (r?.isNotEmpty ?? false) {
        r.removeWhere((element) => element.parent.type == PARAM_EVENT_DETAILS);

        ///Sort list
        r?.sort((a, b) {
          return (b?.parent?.priority ?? -1)
              .toString()
              .compareTo((a?.parent?.priority ?? -1).toString());
        });

        r?.forEach((element) async {
          items.add(ClusterItem(
            LatLng(
              double.parse(element.lat),
              double.parse(element.long),
            ),
            item: Place(
              name: element.street,
              amenityModel: element,
              title: element.parent.title,
              snippet: element.address,
            ),
          ));
        });
      }
      manager.setItems(items);

      return state.copyWith(
        amenities: r,
        currentExperience: event.areaItem,
      );
    });
  }
}

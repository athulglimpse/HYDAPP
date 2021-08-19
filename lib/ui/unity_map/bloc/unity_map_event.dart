part of 'unity_map_bloc.dart';

@immutable
abstract class UnityMapEvent {}

class SelectExperience extends UnityMapEvent {
  final String keyword;
  final double lat;
  final double long;
  final double distance;
  final AreaItem areaItem;

  SelectExperience({
    this.areaItem,
    this.keyword,
    this.lat,
    this.long,
    this.distance,
  });
}

class LocationChangeEvent extends UnityMapEvent {
  final String keyword;
  final double lat;
  final double long;
  final double distance;
  final int experience_id;

  LocationChangeEvent({
    this.lat,
    this.long,
    this.distance = DEFAULT_DISTANCE,
    this.experience_id,
    @required this.keyword,
  });
}

class OpenGuideDirection extends UnityMapEvent {
  final LocationResponse locationResponse;
  final LocationData locationData;

  OpenGuideDirection(this.locationResponse, this.locationData);
}

class CloseDirection extends UnityMapEvent {}

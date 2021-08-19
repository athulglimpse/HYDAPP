part of 'map_page_bloc.dart';

@immutable
abstract class MapPageEvent {}

class SearchEvent extends MapPageEvent {
  final String keyword;
  final double distances;
  final double lat;
  final double long;
  final AreaItem areaItem;

  SearchEvent({
    @required this.keyword,
    this.lat,
    this.long,
    this.distances = DEFAULT_DISTANCE,
    this.areaItem,
  });
}

class UpdateMarker extends MapPageEvent {
  final Set<Marker> markers;

  UpdateMarker(this.markers);
}

class OnSelectMarker extends MapPageEvent {
  final Place place;

  OnSelectMarker({
    @required this.place,
  });
}

class UnSelectMarker extends MapPageEvent {}

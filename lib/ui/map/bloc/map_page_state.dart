part of 'map_page_bloc.dart';

class MapPageState extends Equatable {
  final List<AmenityModel> amenities;
  final List<AreaItem> listExperiences;
  final AreaItem currentExperience;
  final Place markerSelected;
  final Set<Marker> markers;

  MapPageState({
    this.amenities,
    this.markerSelected,
    this.markers,
    this.listExperiences,
    this.currentExperience,
  });

  ///init State with data cache if has
  factory MapPageState.initial(
      HomeRepository homeRepository, LocationRepository locationRepository) {
    final areas = homeRepository.getExperiences();
    return MapPageState(
      listExperiences: areas,
      markers: const {},
      amenities: locationRepository.getNearBy(),
      currentExperience: (areas != null && areas.isNotEmpty) ? areas[0] : null,
    );
  }

  MapPageState copyWith({
    List<AmenityModel> amenities,
    List<AreaItem> listExperiences,
    AreaItem currentExperience,
    Set<Marker> markers,
    Place markerSelected,
  }) {
    return MapPageState(
      amenities: amenities ?? this.amenities,
      markers: markers ?? this.markers,
      markerSelected: markerSelected ?? this.markerSelected,
      listExperiences: listExperiences ?? this.listExperiences,
      currentExperience: currentExperience ?? this.currentExperience,
    );
  }

  MapPageState clearSelectMarker() {
    return MapPageState(
      amenities: amenities,
      markerSelected: null,
      markers: markers,
      listExperiences: listExperiences,
      currentExperience: currentExperience,
    );
  }

  @override
  List<Object> get props => [
        currentExperience,
        markerSelected,
        markers,
        markerSelected?.snippet ?? '',
        listExperiences,
        amenities,
      ];
}

class MapPageError extends MapPageState {
  final String msg;

  MapPageError({this.msg, MapPageState state})
      : super(
          amenities: state.amenities,
          listExperiences: state.listExperiences,
          currentExperience: state.currentExperience,
        );
}

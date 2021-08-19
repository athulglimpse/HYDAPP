part of 'unity_map_bloc.dart';

@immutable
class UnityMapState extends Equatable {
  final List<AreaItem> listExperiences;
  final AreaItem currentExperience;
  final List<AmenityModel> amenities;
  final DirectionRequest directionRequest;
  final bool findDirection;
  final String selectedLocationId;
  final bool needUpdateUnity;

  UnityMapState({
    this.amenities,
    this.selectedLocationId,
    this.directionRequest,
    this.needUpdateUnity = false,
    this.findDirection = false,
    this.listExperiences,
    this.currentExperience,
  });

  factory UnityMapState.initial(HomeRepository homeRepository) {
    final listExpers = homeRepository.getExperiences();
    return UnityMapState(
      listExperiences: listExpers,
      currentExperience: ((listExpers?.length ?? 0) > 0) ? listExpers[0] : null,
    );
  }

  UnityMapState copyWith({
    bool findDirection,
    String selectedLocationId,
    bool needUpdateUnity,
    AreaItem currentExperience,
    List<AreaItem> listExperiences,
    List<AmenityModel> amenities,
    DirectionRequest directionRequest,
  }) {
    return UnityMapState(
      currentExperience: currentExperience ?? this.currentExperience,
      needUpdateUnity: needUpdateUnity ?? false,
      findDirection: findDirection ?? this.findDirection,
      listExperiences: listExperiences ?? this.listExperiences,
      amenities: amenities ?? this.amenities,
      selectedLocationId: selectedLocationId ?? this.selectedLocationId,
      directionRequest: directionRequest ?? this.directionRequest,
    );
  }

  @override
  List<Object> get props => [
        amenities,
        directionRequest,
        findDirection,
        selectedLocationId,
        needUpdateUnity,
        listExperiences,
        currentExperience,
      ];
}

class MapPageError extends UnityMapState {
  final String msg;

  MapPageError(this.msg);

  @override
  List<Object> get props => [msg];
}

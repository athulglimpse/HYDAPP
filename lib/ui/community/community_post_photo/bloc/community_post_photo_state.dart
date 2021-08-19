part of 'community_post_photo_bloc.dart';

@immutable
class CommunityPostPhotoState extends Equatable {
  final PostPhotoRoute currentRoute;
  final String pathImage;
  final bool isRefreshing;
  final List<AmenityModel> amenities;
  final AmenityModel selectedAmenity;

  CommunityPostPhotoState({
    this.currentRoute,
    this.isRefreshing,
    this.pathImage,
    this.amenities,
    this.selectedAmenity,
  });

  factory CommunityPostPhotoState.initial(
      {UserRepository userRepository,
      UploadPhotos uploader,
      LocationRepository locationRepository}) {
    return CommunityPostPhotoState(
      currentRoute: PostPhotoRoute.enterPostPhotoForm,
      pathImage: '',
      isRefreshing: false,
      amenities: const [],
    );
  }

  CommunityPostPhotoState copyWith(
      {PostPhotoRoute currentRoute,
      String pathImage,
      bool isRefreshing,
      List<AmenityModel> amenities,
      AmenityModel selectedAmenity}) {
    return CommunityPostPhotoState(
        pathImage: pathImage ?? this.pathImage,
        isRefreshing: isRefreshing ?? false,
        currentRoute: currentRoute ?? this.currentRoute,
        amenities: amenities ?? this.amenities,
        selectedAmenity: selectedAmenity ?? this.selectedAmenity);
  }

  @override
  List<Object> get props => [
        currentRoute,
        pathImage,
        selectedAmenity,
        amenities,
        isRefreshing,
      ];

  @override
  String toString() {
    return '''MainState {
      currentRoute:$currentRoute
      pathImage:$pathImage
      amenities:$amenities
      selectedAmenity:$selectedAmenity
    }''';
  }
}

class CommunityPostPhotoPageError extends CommunityPostPhotoState {
  final String msg;

  CommunityPostPhotoPageError(this.msg);
}

enum PostPhotoStatus { success, failed }

enum PostPhotoRoute {
  enterPostPhotoForm,
  enterCongratulation,
}

part of 'community_post_photo_bloc.dart';

@immutable
abstract class CommunityPostPhotoEvent {}

class AddImagePost extends CommunityPostPhotoEvent {
  final String path;

  AddImagePost(this.path);
}

class SubmitPostPhoto extends CommunityPostPhotoEvent {
  final String caption;
  final String assetId;

  SubmitPostPhoto(this.caption, this.assetId);
}

class SearchLocation extends CommunityPostPhotoEvent {
  final double lat;
  final double long;
  final String id;
  final CommunityPostPhotoState state;
  SearchLocation({
    this.id,
    this.lat,
    this.long,
    this.state,
  });
}

class SelectedAmenity extends CommunityPostPhotoEvent {
  final AmenityModel amenity;

  SelectedAmenity(this.amenity);
}

class CommunityPostPhotoError extends CommunityPostPhotoState {
  final String msg;

  CommunityPostPhotoError(this.msg);
}

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/data/model/places_model.dart';
import 'package:meta/meta.dart';

import '../../../../common/di/injection/injector.dart';
import '../../../../data/model/amenity_model.dart';
import '../../../../data/model/update_model.dart';
import '../../../../data/repository/location_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../data/source/api_end_point.dart';
import '../../../../data/source/upload_photo.dart';

part 'community_post_photo_event.dart';
part 'community_post_photo_state.dart';

class CommunityPostPhotoBloc
    extends Bloc<CommunityPostPhotoEvent, CommunityPostPhotoState> {
  final UserRepository userRepository;
  final LocationRepository locationRepository;

  CommunityPostPhotoBloc({this.userRepository, this.locationRepository})
      : super(CommunityPostPhotoState.initial(
            userRepository: userRepository,
            locationRepository: locationRepository));

  @override
  Stream<CommunityPostPhotoState> mapEventToState(
      CommunityPostPhotoEvent event) async* {
    if (event is AddImagePost) {
      yield state.copyWith(pathImage: event.path);
    } else if (event is SubmitPostPhoto) {
      final uploader = sl<UploadPhotos>();
      await uploader.uploadFile(UploadModel.init(file: [
        File(state.pathImage)
      ], dataPost: {
        'caption': event.caption,
        'asset_id': event.assetId,
        'place': state.selectedAmenity?.parent?.id ?? '',
        'experience':
            state?.selectedAmenity?.parent?.experience?.id.toString() ?? '',
      }, typePost: TypePost.ADD_COMMUNITY_POST_PHOTO));
      yield state.copyWith(currentRoute: PostPhotoRoute.enterCongratulation);
    } else if (event is SearchLocation) {
      yield state.copyWith(isRefreshing: true);
      yield* _mapSearchLocation(event);
    } else if (event is SelectedAmenity) {
      yield state.copyWith(
        selectedAmenity: event.amenity,
      );
    }
  }

  Stream<CommunityPostPhotoState> _mapSearchLocation(
      SearchLocation event) async* {
    final data = await locationRepository.searchNearBy(
      lat: event.lat,
      long: event.long,
      content: '',
      experience_id: 0,
    );

    yield data.fold((l) => state, (r) {
      r.removeWhere((item) => item.parent.type != PARAM_AMENITIES_DETAILS);
      final amenityModel = r?.where((item) {
        return item?.parent?.id?.toString() == (event?.id ?? '');
      })?.toList();
      return state.copyWith(
        amenities: (amenityModel?.isNotEmpty ?? false) ? amenityModel : r,
        selectedAmenity:
            ((amenityModel?.length ?? 0) > 0) ? amenityModel[0] : null,
      );
    });
  }

  @override
  void onTransition(
      Transition<CommunityPostPhotoEvent, CommunityPostPhotoState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}

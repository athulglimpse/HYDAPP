import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/activity_model.dart';
import '../../../../data/model/community_model.dart';
import '../../../../data/model/suggestion.dart';
import '../../../../data/repository/activity_repository.dart';
import '../../../../data/repository/home_repository.dart';
import '../../../../data/source/failure.dart';

part 'weekend_activity_detail_event.dart';
part 'weekend_activity_detail_state.dart';

class WeekendActivityDetailBloc
    extends Bloc<WeekendActivityDetailEvent, WeekendActivityDetailState> {
  final ActivityRepository activityRepository;
  final HomeRepository homeRepository;

  WeekendActivityDetailBloc({this.activityRepository, this.homeRepository})
      : super(WeekendActivityDetailState.initial(
            activityRepository, homeRepository));

  @override
  Stream<WeekendActivityDetailState> mapEventToState(
    WeekendActivityDetailEvent event,
  ) async* {
    if (event is CopyActivityInfo) {
      final id = event?.item?.id.toString() ?? '';
      // final cateId = event?.item?..toString() ?? '';

      yield state.copyWith(
        activityModel: event.item,
        activitiesAlsoLike: activityRepository.getActivityAlsoLike(id: id),
      );

      add(FetchActivityAlsoLike(id));
      add(FetchActivityDetail(id));
      // add(FetchFromCommunity(id));
    } else if (event is FetchActivityDetail) {
      // final amenityDetailModel = amenityRepository.getAmenityDetail(event.id);
      // final amenities = amenityRepository.getAmenityAlsoLike();
      // yield state.copyWith(
      //     amenityDetailModel: amenityDetailModel, amenitiesAlsoLike: amenities);
      //
      // final resultAmenityDetail =
      //     await amenityRepository.fetchAmenityDetail(event.id);
      // yield* _handleAmenityDetailResult(resultAmenityDetail);
      //
      // final resultAmenitiesAlsoLike =
      //     await amenityRepository.fetchAmenityAlsoLike();
      // yield* _handleAmenityAlsoLikeResult(resultAmenitiesAlsoLike);
    } else if (event is FetchActivityAlsoLike) {
      final data = await activityRepository.fetchActivityAlsoLike(id: event.id);
      yield* _handleActivityAlsoLikeResult(data);
    } else if (event is FetchFromCommunity) {
      yield* handleCommunityResult(await homeRepository.fetchListCommunity(
        pageIndex: 0,
        cateId: event.cateId,
      ));
    } else if (event is AddPostFavorite) {
      if (event.communityPost.isFavorite != null) {
        event.communityPost.isFavorite = !event.communityPost.isFavorite;
      }
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());
      await homeRepository.addFavorite(event.communityPost.id.toString(),
          event.communityPost.isFavorite ?? false, FavoriteType.COMMUNITY_POST);
      add(FetchFromCommunity());
    } else if (event is AddToFavorite) {
      // if (state.activityModel.isFavorite != null) {
      //   state.activityModel.isFavorite =
      //       !state.activityModel.isFavorite;
      // }
      // yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());
      //
      // await homeRepository.addFavorite(
      //     event.id, state.activityModel.isFavorite, FavoriteType.AMENITY);
      //
      // add(FetchAmenityDetail(id: event.id));
    }
  }

  Stream<WeekendActivityDetailState> handleCommunityResult(
      Either<Failure, CommunityModel> result) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(listCommunities: value.allPost),
    );
  }

  Stream<WeekendActivityDetailState> _handleAmenityDetailResult(
      Either<Failure, ActivityModel> result) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(activityModel: value),
    );
  }

  Stream<WeekendActivityDetailState> _handleActivityAlsoLikeResult(
      Either<Failure, List<ActivityModel>> result) async* {
    yield result.fold(
      (failure) => state,
      (value) => state.copyWith(activitiesAlsoLike: value),
    );
  }
}

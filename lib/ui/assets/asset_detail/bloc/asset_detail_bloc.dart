import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:marvista/data/model/community_model.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/asset_detail.dart';
import '../../../../data/model/places_model.dart';
import '../../../../data/model/user_info.dart';
import '../../../../data/repository/asset_repository.dart';
import '../../../../data/repository/home_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../data/source/failure.dart';

part 'asset_detail_event.dart';
part 'asset_detail_state.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  final AssetRepository assetRepository;
  final HomeRepository homeRepository;
  final UserRepository userRepository;

  AssetDetailBloc({
    this.assetRepository,
    this.userRepository,
    this.homeRepository,
  }) : super(AssetDetailState.initial(userRepository, homeRepository));

  @override
  Stream<AssetDetailState> mapEventToState(
    AssetDetailEvent event,
  ) async* {
    if (event is CopyAssetDetail) {
      yield state.copyWith(
          assetDetail: AssetDetail.fromJson(event.placeModel.toJson()));
      yield state.copyWith(
          assetDetail:
              assetRepository.getAssetDetail(event.placeModel.id.toString()));
      yield state.copyWith(isRefreshing: true);
    } else if (event is AddPostFavorite) {
      if (event.communityPost.isFavorite != null) {
        event.communityPost.isFavorite = !event.communityPost.isFavorite;
      }
      // yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());
      await homeRepository.addFavorite(event.communityPost.id.toString(),
          event.communityPost.isFavorite ?? false, FavoriteType.COMMUNITY_POST);
    } else if (event is AddFavorite) {
      if (state.assetDetail.isFavorite != null) {
        state.assetDetail.isFavorite = !state.assetDetail.isFavorite;
      }
      // yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      await homeRepository.addFavorite(
          event.id, state.assetDetail.isFavorite, FavoriteType.AMENITY);

      // add(FetchAssetDetail(event.id));
      // add(FetchAlsoLike(event.id));
    } else if (event is FetchCommunityPost) {
      final result = await homeRepository.fetchListCommunity(
          amenityId: event?.id?.toString() ?? '');
      yield result.fold((l) => state, (r) => state.copyWith(communityModel: r));
    } else if (event is FetchAlsoLike) {
      final assets = await assetRepository.fetchAmenitiesAlsoLike(event.id);
      yield* _handleAmenitiesAlsoLikeResult(assets);
    } else if (event is FetchAssetDetail) {
      final result = await assetRepository.fetchAmenityDetail(event.id);
      yield* _handleAssetDetailResult(result);
      add(FetchCommunityPost(id: event.id));
    }
  }

  Stream<AssetDetailState> _handleAmenitiesAlsoLikeResult(
      Either<Failure, List<PlaceModel>> result) async* {
    yield result.fold(
      (failure) => state,
      (result) => state.copyWith(alsoLikeAssets: result),
    );
  }

  Stream<AssetDetailState> _handleAssetDetailResult(
      Either<Failure, AssetDetail> result) async* {
    yield result.fold(
      (failure) => state,
      (result) => state.copyWith(assetDetail: result),
    );
  }
}

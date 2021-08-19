import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../common/di/injection/injector.dart';
import '../../../../data/model/asset_detail.dart';
import '../../../../data/model/update_model.dart';
import '../../../../data/repository/asset_repository.dart';
import '../../../../data/repository/post_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../data/source/failure.dart';
import '../../../../data/source/upload_photo.dart';
import '../util/community_write_review_util.dart';

part 'community_write_review_event.dart';
part 'community_write_review_state.dart';

class CommunityWriteReviewBloc
    extends Bloc<CommunityWriteReviewEvent, CommunityWriteReviewState> {
  final UserRepository userRepository;
  final AssetRepository assetRepository;
  final PostRepository postRepository;
  CommunityWriteReviewBloc(
      {this.userRepository, this.assetRepository, this.postRepository})
      : super(
            CommunityWriteReviewState.initial(userRepository: userRepository));

  @override
  Stream<CommunityWriteReviewState> mapEventToState(
      CommunityWriteReviewEvent event) async* {
    if (event is AddImageWriteReview) {
      final mapFilter = <String, Map>{};
      event.path.forEach((element) {
        final filterValue = {};
        filterValue.addAll({
          WRITE_REVIEW_KEY_ID: element,
          WRITE_REVIEW_KEY_VALUE: element,
        });
        mapFilter[element] = filterValue;
      });
      yield state.copyWith(listImageSelected: mapFilter);
    } else if (event is SubmitWriteReview) {
      final file = <File>[];
      state.listImageSelected.entries.toList().forEach((element) {
        file.add(File(element.key));
      });
      if (file.isNotEmpty) {
        final uploader = sl<UploadPhotos>();
        await uploader.uploadFile(UploadModel.init(
            file: file,
            dataPost: {
              'caption': event.caption,
              'rate': event.rate,
              'asset_id': event.assetId,
              'experience': event.experience,
            },
            typePost: TypePost.ADD_COMMUNITY_WRITE_REVIEW));
      } else {
        await postRepository.postCommunityReview(
            event.caption, event.assetId, event.experience, event.rate, []);
      }
      yield state.copyWith(currentRoute: WriteReviewRoute.enterCongratulation);
    } else if (event is DeleteImageWriteReview) {
      final mapImageSelected = <String, Map>{};
      mapImageSelected.addAll(state.listImageSelected);
      if (mapImageSelected.containsKey(event.id)) {
        mapImageSelected.remove(event.id);
      }
      yield state.copyWith(listImageSelected: mapImageSelected);
    } else if (event is FetchSuggestionsAmenities) {
      final result = await assetRepository.fetchSearchAsset(event.content);
      yield* _handleSearchAssetResult(result);
    } else if (event is FetchAssetDetail) {
      final result = await assetRepository.fetchAmenityDetail(event.id);
      yield result.fold(
          (l) => state, (r) => state.copyWith(selectedAssetDetail: r));
    } else if (event is SelectedAssetDetail) {
      yield state.copyWith(selectedAssetDetail: event.assetDetail);
    } else if (event is FocusFieldSearch) {
      yield state.copyWith(isFocusFieldSearch: event.isFocusFieldSearch);
    }
  }

  @override
  void onTransition(
      Transition<CommunityWriteReviewEvent, CommunityWriteReviewState>
          transition) {
    print(transition);
    super.onTransition(transition);
  }

  Stream<CommunityWriteReviewState> _handleSearchAssetResult(
    Either<Failure, List<AssetDetail>> resultServer,
  ) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        return state.copyWith(
            listAssetDetail: result,
            timeRefresh: DateTime.now().toIso8601String());
      },
    );
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../common/dialog/sort_tool_dialog.dart';
import '../../../../data/model/category_model.dart';
import '../../../../data/model/places_model.dart';
import '../../../../data/repository/asset_repository.dart';
import '../asset_see_all_grid_page.dart';
import '../interactor/asset_see_all_interact.dart';

part 'asset_see_all_event.dart';
part 'asset_see_all_state.dart';

class AssetSeeAllBloc extends Bloc<AssetSeeAllEvent, AssetSeeAllState> {
  final AssetRepository assetRepository;
  final AssetSeeAllInteract assetSeeAllInteract;
  AssetSeeAllBloc({this.assetSeeAllInteract, this.assetRepository})
      : super(AssetSeeAllState.initial());

  @override
  Stream<AssetSeeAllState> mapEventToState(
    AssetSeeAllEvent event,
  ) async* {
    if (event is InitAssetFromCache) {
      final assets = assetRepository.getAssets(event.viewAssetType);
      assetSeeAllInteract.doSortAZ(assets, SortType.ASC);
      var groups = <CategoryModel, List<PlaceModel>>{};
      groups = groupBy(assets, (e) {
        return e.category;
      });

      yield state.copyWith(allAssets: assets, listGroupCategories: groups);

      // add(FetchAsset(event.viewAssetType));
    } else if (event is OnChangeCategory) {
      yield state.copyWith(currentCate: event.categoryModel);
    } else if (event is FetchAlsoLike) {
      final assets = await assetRepository.fetchAmenitiesAlsoLike(event.id);
      yield* assetSeeAllInteract.handleAmenitiesAlsoLikeResult(assets, state);
    } else if (event is FetchAsset) {
      final assets = await assetRepository.fetchAmenities(
          experiId: event.experienceId?.toString() ?? '',
          filterAdv: event.filterAdv,
          filter: event.facilitesId,
          viewAssetType: event.viewAssetType);
      yield* assetSeeAllInteract.handleAssetsResult(assets, state);

      if (state?.allAssets?.isNotEmpty ?? false) {
        add(FetchAlsoLike(state?.allAssets[0].id.toString()));
      }
    } else if (event is DoSortItems) {
      assetSeeAllInteract.doSortAZ(state.allAssets, event.sortType);
      yield state.copyWith(sortType: event.sortType);
    }
  }
}

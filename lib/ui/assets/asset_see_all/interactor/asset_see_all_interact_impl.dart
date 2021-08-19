import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/dialog/sort_tool_dialog.dart';
import '../../../../data/model/category_model.dart';
import '../../../../data/model/places_model.dart';
import '../../../../data/source/failure.dart';
import '../bloc/asset_see_all_bloc.dart';
import 'asset_see_all_interact.dart';

class AssetSeeAllInteractImpl extends AssetSeeAllInteract {
  AssetSeeAllInteractImpl();

  @override
  Stream<AssetSeeAllState> handleAmenitiesAlsoLikeResult(
      Either<Failure, List<PlaceModel>> resultServer,
      AssetSeeAllState state) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        doSortAZ(result, state.sortType);
        return state.copyWith(alsoLikeAssets: result, sortType: state.sortType);
      },
    );
  }

  @override
  Stream<AssetSeeAllState> handleAssetsResult(
      Either<Failure, List<PlaceModel>> resultServer,
      AssetSeeAllState state) async* {
    yield resultServer.fold(
      (failure) {
        return state;
      },
      (result) {
        doSortAZ(result, state.sortType);
        var groups = <CategoryModel, List<PlaceModel>>{};
        groups = groupBy(result, (e) {
          return e.category;
        });
        return state.copyWith(
          allAssets: result,
          listGroupCategories: groups,
          sortType: state.sortType,
        );
      },
    );
  }

  @override
  void doSortAZ(List<PlaceModel> places, SortType sortType) {
    if (sortType == SortType.ASC) {
      places.sort((a, b) {
        return a?.title
                ?.toLowerCase()
                ?.trim()
                ?.compareTo(b?.title?.toLowerCase()?.trim() ?? '') ??
            0;
      });
    } else {
      places.sort((a, b) {
        return b?.title
                ?.toLowerCase()
                ?.trim()
                ?.compareTo(a?.title?.toLowerCase()?.trim() ?? '') ??
            0;
      });
    }
  }
}

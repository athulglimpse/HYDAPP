import 'package:dartz/dartz.dart';

import '../../../../common/dialog/sort_tool_dialog.dart';
import '../../../../data/model/places_model.dart';
import '../../../../data/source/failure.dart';
import '../bloc/asset_see_all_bloc.dart';

abstract class AssetSeeAllInteract {
  Stream<AssetSeeAllState> handleAmenitiesAlsoLikeResult(
      Either<Failure, List<PlaceModel>> resultServer, AssetSeeAllState state);

  Stream<AssetSeeAllState> handleAssetsResult(
      Either<Failure, List<PlaceModel>> resultServer, AssetSeeAllState state);

  void doSortAZ(List<PlaceModel> places, SortType sortType);
}

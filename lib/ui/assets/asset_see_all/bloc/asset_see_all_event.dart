part of 'asset_see_all_bloc.dart';

@immutable
abstract class AssetSeeAllEvent {}

class InitAssetFromCache extends AssetSeeAllEvent {
  final ViewAssetType viewAssetType;

  InitAssetFromCache(this.viewAssetType);
}

class FetchAlsoLike extends AssetSeeAllEvent {
  final String id;

  FetchAlsoLike(this.id);
}

class FetchAsset extends AssetSeeAllEvent {
  final ViewAssetType viewAssetType;
  final int experienceId;
  final String facilitesId;
  final Map<int, Map> filterAdv;

  FetchAsset({
    this.viewAssetType,
    this.filterAdv,
    this.facilitesId,
    this.experienceId,
  });
}

class DoSortItems extends AssetSeeAllEvent {
  final SortType sortType;

  DoSortItems(this.sortType);
}

class OnChangeCategory extends AssetSeeAllEvent {
  final CategoryModel categoryModel;

  OnChangeCategory(this.categoryModel);
}

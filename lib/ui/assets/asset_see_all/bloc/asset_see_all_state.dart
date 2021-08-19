part of 'asset_see_all_bloc.dart';

@immutable
class AssetSeeAllState extends Equatable {
  final List<PlaceModel> alsoLikeAssets;
  final Map<CategoryModel, List<PlaceModel>> listGroupCategories;
  final SortType sortType;
  final CategoryModel currentCate;
  final List<PlaceModel> allAssets;

  AssetSeeAllState({
    this.sortType,
    this.listGroupCategories,
    this.allAssets,
    this.currentCate,
    this.alsoLikeAssets,
  });

  ///init State with data cache if has
  factory AssetSeeAllState.initial() {
    return AssetSeeAllState(
      alsoLikeAssets: null,
      sortType: SortType.ASC,
      allAssets: null,
      currentCate: null,
      listGroupCategories: null,
    );
  }

  AssetSeeAllState copyWith({
    List<PlaceModel> alsoLikeAssets,
    SortType sortType,
    CategoryModel currentCate,
    Map<CategoryModel, List<PlaceModel>> listGroupCategories,
    List<PlaceModel> allAssets,
  }) {
    return AssetSeeAllState(
      sortType: sortType ?? this.sortType,
      allAssets: allAssets ?? this.allAssets,
      currentCate: currentCate,
      listGroupCategories: listGroupCategories ?? this.listGroupCategories,
      alsoLikeAssets: alsoLikeAssets ?? this.alsoLikeAssets,
    );
  }

  @override
  List<Object> get props => [
        alsoLikeAssets,
        sortType,
        currentCate,
        allAssets,
        listGroupCategories,
      ];
}

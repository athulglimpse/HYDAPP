part of 'community_write_review_bloc.dart';

@immutable
class CommunityWriteReviewState extends Equatable {
  final WriteReviewRoute currentRoute;
  final Map<String, Map> listImageSelected;
  final AssetDetail selectedAssetDetail;
  final List<AssetDetail> listAssetDetail;
  final bool isFocusFieldSearch;
  final String timeRefresh;

  CommunityWriteReviewState({
    this.currentRoute,
    this.listImageSelected,
    this.timeRefresh,
    this.selectedAssetDetail,
    this.isFocusFieldSearch,
    this.listAssetDetail,
  });

  factory CommunityWriteReviewState.initial({UserRepository userRepository}) {
    return CommunityWriteReviewState(
      currentRoute: WriteReviewRoute.enterWriteReviewForm,
      listImageSelected: const <String, Map>{},
      selectedAssetDetail: null,
      timeRefresh: null,
      listAssetDetail: const <AssetDetail>[],
      isFocusFieldSearch: false,
    );
  }

  CommunityWriteReviewState copyWith({
    String timeRefresh,
    WriteReviewRoute currentRoute,
    Map<String, Map> listImageSelected,
    AssetDetail selectedAssetDetail,
    List<AssetDetail> listAssetDetail,
    bool isFocusFieldSearch,
  }) {
    return CommunityWriteReviewState(
        timeRefresh: timeRefresh ?? this.timeRefresh,
        listImageSelected: listImageSelected ?? this.listImageSelected,
        listAssetDetail: listAssetDetail ?? this.listAssetDetail,
        selectedAssetDetail: selectedAssetDetail ?? this.selectedAssetDetail,
        isFocusFieldSearch: isFocusFieldSearch ?? this.isFocusFieldSearch,
        currentRoute: currentRoute ?? this.currentRoute);
  }

  @override
  List<Object> get props => [
        currentRoute,
        listImageSelected,
        timeRefresh,
        listAssetDetail,
        isFocusFieldSearch,
        selectedAssetDetail
      ];

  @override
  String toString() {
    return '''MainState {
      currentRoute:$currentRoute
      selectedAssetDetail:$selectedAssetDetail
      isFocusFieldSearch:$isFocusFieldSearch
      listAssetDetail:$listAssetDetail
      listImageSelected:$listImageSelected
    }''';
  }
}

enum WriteReviewStatus { success, failed }

enum WriteReviewRoute {
  enterWriteReviewForm,
  enterCongratulation,
}

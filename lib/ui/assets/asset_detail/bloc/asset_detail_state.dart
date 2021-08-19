part of 'asset_detail_bloc.dart';

@immutable
class AssetDetailState extends Equatable {
  final AssetDetail assetDetail;
  final List<PlaceModel> alsoLikeAssets;
  final CommunityModel communityModel;
  final String timeRefresh;
  final bool isRefreshing;
  final UserInfo userInfo;

  AssetDetailState({
    this.assetDetail,
    this.userInfo,
    this.communityModel,
    this.isRefreshing,
    this.alsoLikeAssets,
    this.timeRefresh,
  });

  ///init State with data cache if has
  factory AssetDetailState.initial(
      UserRepository userRepository, HomeRepository homeRepository) {
    return AssetDetailState(
      assetDetail: null,
      alsoLikeAssets: null,
      communityModel: homeRepository.getCommunityListInfo(),
      isRefreshing: false,
      userInfo: userRepository.getCurrentUser(),
    );
  }

  AssetDetailState copyWith({
    AssetDetail assetDetail,
    String timeRefresh,
    bool isRefreshing,
    UserInfo userInfo,
    CommunityModel communityModel,
    List<PlaceModel> alsoLikeAssets,
  }) {
    return AssetDetailState(
      assetDetail: assetDetail ?? this.assetDetail,
      timeRefresh: timeRefresh ?? this.timeRefresh,
      communityModel: communityModel ?? this.communityModel,
      isRefreshing: isRefreshing ?? false,
      userInfo: userInfo ?? this.userInfo,
      alsoLikeAssets: alsoLikeAssets ?? this.alsoLikeAssets,
    );
  }

  @override
  List<Object> get props =>
      [assetDetail, timeRefresh, alsoLikeAssets,isRefreshing, userInfo, communityModel];
}

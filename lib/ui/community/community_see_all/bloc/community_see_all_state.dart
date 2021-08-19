part of 'community_see_all_bloc.dart';

@immutable
class CommunitySeeAllState extends Equatable {
  final List<CommunityPost> listTrendingPosts;
  final List<CommunityPost> listAllPosts;
  final String timeRefresh;

  CommunitySeeAllState({
    this.listTrendingPosts,
    this.listAllPosts,
    this.timeRefresh,
  });

  factory CommunitySeeAllState.initial(HomeRepository homeRepository) {
    final communityModel = homeRepository.getCommunityListInfo();
    return CommunitySeeAllState(
        listTrendingPosts: communityModel?.trendingPost,
        listAllPosts: communityModel?.allPost);
  }

  CommunitySeeAllState copyWith(
      {List<CommunityPost> listTrendingPosts,
      String timeRefresh,
      List<CommunityPost> listAllPosts}) {
    return CommunitySeeAllState(
        timeRefresh: timeRefresh ?? this.timeRefresh,
        listTrendingPosts: listTrendingPosts ?? this.listTrendingPosts,
        listAllPosts: listAllPosts ?? this.listAllPosts);
  }

  @override
  List<Object> get props => [listTrendingPosts, listAllPosts, timeRefresh];
}

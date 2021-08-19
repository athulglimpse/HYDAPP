part of 'weekend_activity_detail_bloc.dart';

@immutable
abstract class WeekendActivityDetailEvent {}

class FetchActivityDetail extends WeekendActivityDetailEvent {
  final String id;

  FetchActivityDetail(this.id);
}

class CopyActivityInfo extends WeekendActivityDetailEvent {
  final ActivityModel item;

  CopyActivityInfo(this.item);
}

class FetchActivityAlsoLike extends WeekendActivityDetailEvent {
  final String id;

  FetchActivityAlsoLike(this.id);
}

class FetchFromCommunity extends WeekendActivityDetailEvent {
  final String cateId;

  FetchFromCommunity({this.cateId});
}

class AddToFavorite extends WeekendActivityDetailEvent {
  final String id;
  final String cate;

  AddToFavorite({this.id, this.cate});
}

class AddPostFavorite extends WeekendActivityDetailEvent {
  final CommunityPost communityPost;

  AddPostFavorite(this.communityPost);
}

part of 'community_see_all_bloc.dart';

@immutable
abstract class CommunitySeeAllEvent {}

class AddPostToFavorite extends CommunitySeeAllEvent {
  final CommunityPost communityPost;

  AddPostToFavorite(this.communityPost);
}

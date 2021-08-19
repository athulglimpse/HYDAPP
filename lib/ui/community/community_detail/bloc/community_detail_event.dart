part of 'community_detail_bloc.dart';

@immutable
abstract class CommunityDetailEvent {}

class InitPostAndCommentFromCache extends CommunityDetailEvent {
  final CommunityPost communityPost;

  InitPostAndCommentFromCache(this.communityPost);
}

class FetchNewComments extends CommunityDetailEvent {
  final String postId;

  FetchNewComments(this.postId);
}

class FetchPostDetail extends CommunityDetailEvent {
  final String postId;

  FetchPostDetail(this.postId);
}

class FetchMoreComments extends CommunityDetailEvent {}

class FetchNewReply extends CommunityDetailEvent {
  final String commentId;

  FetchNewReply(this.commentId);
}

class FetchMoreReply extends CommunityDetailEvent {
  final String commentId;

  FetchMoreReply(this.commentId);
}

class AddPostFavorite extends CommunityDetailEvent {}

class ShowCommentLayout extends CommunityDetailEvent {}

class HideCommentLayout extends CommunityDetailEvent {}

class LikeComment extends CommunityDetailEvent {
  final CommentModel commentModel;

  LikeComment(this.commentModel);
}

class SharePost extends CommunityDetailEvent {
  SharePost();
}

class AddPostComment extends CommunityDetailEvent {
  final String comment;

  AddPostComment(this.comment);
}

class SwitchReplyLayout extends CommunityDetailEvent {
  final CommentModel commentModel;

  SwitchReplyLayout(this.commentModel);
}

class SwitchCommentLayout extends CommunityDetailEvent {}

class ReplyComment extends CommunityDetailEvent {
  final String commentId;

  final String comment;

  ReplyComment(this.commentId, this.comment);
}

class RemovePostFromFeed extends CommunityDetailEvent {}

class TurnOffPostFromOwner extends CommunityDetailEvent {}

class AddFavorite extends CommunityDetailEvent {
  final String id;

  AddFavorite(this.id);
}
part of 'community_detail_bloc.dart';

@immutable
class CommunityDetailState extends Equatable {
  final PostDetail postDetail;
  final UserInfo userInfo;
  final CommentModel commentReply;
  final bool isReplying;
  final bool isFetchReplying;
  final bool isShowComment;
  final bool isRefreshing;
  final StatusAPISubmit statusAPISubmit;
  final String errorMessage;
  final List<CommentModel> comment;
  // final List<CommentModel> replies;
  final String timeRefresh;

  /// Comment Page index
  final int commentPageIndex;
  final bool isLoadingComments;

  /// reply Page index
  final int replyPageIndex;
  final bool isLoadingReplies;

  CommunityDetailState({
    this.postDetail,
    // this.replies,
    this.isLoadingComments = false,
    this.isFetchReplying = false,
    this.isRefreshing = false,
    this.isLoadingReplies = false,
    this.commentPageIndex = 0,
    this.replyPageIndex = 0,
    this.isReplying = false,
    this.timeRefresh = '',
    this.isShowComment = false,
    this.statusAPISubmit,
    this.errorMessage,
    this.commentReply,
    this.userInfo,
    this.comment,
  });

  factory CommunityDetailState.initial({UserRepository userRepository}) {
    return CommunityDetailState(
      postDetail: PostDetail(),
      // ignore: prefer_const_literals_to_create_immutables
      comment: <CommentModel>[],
      isRefreshing: false,
      isReplying: false,
      isFetchReplying: false,
      isShowComment: false,
      isLoadingComments: false,
      isLoadingReplies: false,
      statusAPISubmit: StatusAPISubmit.NONE,
      userInfo: userRepository.getCurrentUser(),
    );
  }

  CommunityDetailState copyWith({
    PostDetail postDetail,
    List<CommentModel> comment,
    CommentModel commentReply,
    int replyPageIndex,
    int commentPageIndex,
    String timeRefresh,
    StatusAPISubmit statusAPISubmit,
    String errorMessage,
    UserInfo userInfo,
    bool isShowComment,
    bool isFetchReplying,
    bool isLoadingComments,
    bool isRefreshing,
    bool isLoadingReplies,
    bool isReplying,
  }) {
    return CommunityDetailState(
        postDetail: postDetail ?? this.postDetail,
        userInfo: userInfo ?? this.userInfo,
        // replies: replies ?? this.replies,
        isLoadingReplies: isLoadingReplies ?? this.isLoadingReplies,
        timeRefresh: timeRefresh ?? this.timeRefresh,
        isRefreshing: isRefreshing ?? false,
        isFetchReplying: isFetchReplying ?? false,
        isLoadingComments: isLoadingComments ?? this.isLoadingComments,
        replyPageIndex: replyPageIndex ?? this.replyPageIndex,
        commentPageIndex: commentPageIndex ?? this.commentPageIndex,
        statusAPISubmit: statusAPISubmit ?? StatusAPISubmit.NONE,
        errorMessage: errorMessage ?? '',
        isShowComment: isShowComment ?? this.isShowComment,
        commentReply: commentReply ?? this.commentReply,
        isReplying: isReplying ?? this.isReplying,
        comment: comment ?? this.comment);
  }

  @override
  List<Object> get props => [
        postDetail,
        comment,
        comment?.length ?? 0,
        userInfo,
        isReplying,
        isRefreshing,
        commentReply,
        isShowComment,
        isFetchReplying,
        errorMessage,
        isLoadingReplies,
        isLoadingComments,
        // replies?.length ?? 0,
        commentPageIndex,
        timeRefresh,
        replyPageIndex,
        statusAPISubmit,
        commentReply?.replied?.length ?? 0,
      ];

  @override
  String toString() {
    return '''MainState {
      commentPageIndex: $commentPageIndex,
      replyPageIndex: $replyPageIndex,
      postDetail: $postDetail,
      isShowComment: $isShowComment,
      comment: $comment,
      statusAPISubmit: $statusAPISubmit,
      userInfo: $userInfo,
      isReplying: $isReplying,
      timeRefresh: $timeRefresh,
      commentReply: $commentReply,
    }''';
  }
}

enum StatusAPISubmit {
  SUBMIT_FAIL,
  NONE,
  LIKE_COMMENT_SUCCESS,
  ADD_FAVORITE_SUCCESS,
  ADD_COMMENT_SUCCESS,
  REPLY_COMMENT_SUCCESS,
  REMOVE_POST_SUCCESS,
  TURN_OFF_POST_SUCCESS
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../data/model/comment_model.dart';
import '../../../../data/model/community_model.dart';
import '../../../../data/model/post_detail.dart';
import '../../../../data/model/user_info.dart';
import '../../../../data/repository/home_repository.dart';
import '../../../../data/repository/post_repository.dart';
import '../../../../data/repository/user_repository.dart';
import '../../../../data/source/api_end_point.dart';
import '../../../../data/source/failure.dart';
import '../../../../data/source/success.dart';

part 'community_detail_event.dart';
part 'community_detail_state.dart';

class CommunityDetailBloc
    extends Bloc<CommunityDetailEvent, CommunityDetailState> {
  final PostRepository postRepository;
  final HomeRepository homeRepository;
  final UserRepository userRepository;

  CommunityDetailBloc(
      {this.postRepository, this.homeRepository, this.userRepository})
      : super(CommunityDetailState.initial(userRepository: userRepository));

  @override
  Stream<CommunityDetailState> mapEventToState(
    CommunityDetailEvent event,
  ) async* {
    if (event is InitPostAndCommentFromCache) {
      final communityPost = event.communityPost;
      final communityId = communityPost.id.toString();
      final resultLocal = postRepository.getPostDetail(communityId);
      final resultCommentLocal = postRepository.getPostComment(communityId);
      yield state.copyWith(
          comment: resultCommentLocal,
          isRefreshing: true,
          postDetail:
              resultLocal ?? PostDetail.fromJson(communityPost.toJson()));
    } else if (event is FetchPostDetail) {
      final resultServer = await postRepository.fetchPostDetail(event.postId);
      yield* _handleFetchDetailResult(resultServer);
    } else if (event is AddFavorite) {
      if (state.postDetail.place.isFavorite != null) {
        state.postDetail.place.isFavorite = !state.postDetail.place.isFavorite;
      }
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      await homeRepository.addFavorite(
          event.id, state.postDetail.place.isFavorite, FavoriteType.AMENITY);

      // add(FetchPostDetail(state.postDetail.id.toString()));
      // add(FetchAlsoLike(event.id));
    } else if (event is AddPostFavorite) {
      state.postDetail.isFavorite = !state.postDetail.isFavorite;
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      await homeRepository.addFavorite(state.postDetail.id.toString(),
          state.postDetail.isFavorite, FavoriteType.COMMUNITY_POST);
      add(FetchPostDetail(state.postDetail.id.toString()));
    } else if (event is FetchNewComments) {
      final resultCommentServer =
          await postRepository.fetchPostComment(event.postId, pageIndex: 0);

      yield* _handleFetchNewCommentResult(resultCommentServer);
    } else if (event is FetchNewReply) {
      yield state.copyWith(isFetchReplying: true);
      final resultReplyServer = await postRepository.fetchReplyComment(
          state.postDetail.id.toString(), state.commentReply.id.toString(),
          pageIndex: 0);

      yield* _handleFetchNewReplyResult(resultReplyServer);
    } else if (event is FetchMoreReply) {
      final resultReplyServer = await postRepository.fetchReplyComment(
          state.postDetail.id.toString(), state.commentReply.id.toString(),
          pageIndex: state.replyPageIndex + 1);

      yield* _handleFetchMoreReplyResult(resultReplyServer);
    } else if (event is FetchMoreComments) {
      yield state.copyWith(isLoadingComments: true);
      final resultCommentServer = await postRepository.fetchPostComment(
          state.postDetail.id.toString(),
          pageIndex: state.commentPageIndex + 1);

      yield* _handleFetchMoreCommentResult(resultCommentServer);
    } else if (event is SwitchCommentLayout) {
      add(FetchNewComments(state.postDetail.id.toString()));
      yield state.copyWith(isReplying: false, commentReply: null);
    } else if (event is SwitchReplyLayout) {
      add(FetchNewReply(event.commentModel.id.toString()));
      yield state.copyWith(isReplying: true, commentReply: event.commentModel);
    } else if (event is AddPostComment) {
      final userInfo = state.userInfo;
      final newListComment = <CommentModel>[];
      newListComment.add(CommentModel(
        id: -1,
        username: userInfo.fullName,
        liked: false,
        image: userInfo.photo?.url ?? '',
        comment: event.comment,
      ));
      newListComment.addAll(state.comment ?? []);

      yield state.copyWith(comment: newListComment);
      final result = await postRepository.addPostComment(
          state.postDetail.id.toString(), event.comment);
      yield* _handlePostAddCommentResult(result);

      add(FetchNewComments(state.postDetail.id.toString()));
    } else if (event is HideCommentLayout) {
      yield state.copyWith(isShowComment: false);
    } else if (event is ShowCommentLayout) {
      add(FetchNewComments(state.postDetail.id.toString()));
      yield state.copyWith(isShowComment: true);
    } else if (event is LikeComment) {
      event.commentModel.liked = !event.commentModel.liked;
      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      final result = await postRepository.likeComment(
        event.commentModel.id.toString(),
        event.commentModel.liked,
      );
      yield* _handlePostLikeCommentResult(result);
    } else if (event is ReplyComment) {
      final userInfo = state.userInfo;
      state.commentReply?.replied?.insert(
          0,
          CommentModel(
            id: -1,
            username: userInfo.fullName,
            liked: false,
            image: userInfo.photo?.url ?? '',
            comment: event.comment,
          ));

      yield state.copyWith(timeRefresh: DateTime.now().toIso8601String());

      final result = await postRepository.addReplyComment(
          state.postDetail.id.toString(), event.commentId, event.comment);
      yield* _handlePostReplyCommentResult(result);

      add(FetchNewReply(event.commentId));
    } else if (event is RemovePostFromFeed) {
      await postRepository.removePostFromFeed(
          state.postDetail.id.toString(), 'add', ENTITY_TYPE_POST);
      yield state;
    } else if (event is TurnOffPostFromOwner) {
      await postRepository.turnOffPostFromOwner(
          state.postDetail.id.toString(), 'add', ENTITY_TYPE_POST);
      yield state;
    }
  }

  Stream<CommunityDetailState> _handleFetchDetailResult(
      Either<Failure, PostDetail> resultServer) async* {
    yield resultServer.fold(
      (failure) => state.copyWith(
          statusAPISubmit: StatusAPISubmit.NONE,
          errorMessage: (failure as RemoteDataFailure).errorMessage),
      (result) => state.copyWith(postDetail: result),
    );
  }

  Stream<CommunityDetailState> _handleFetchNewCommentResult(
      Either<Failure, List<CommentModel>> resultServer) async* {
    yield resultServer.fold(
        (failure) => state.copyWith(
            statusAPISubmit: StatusAPISubmit.NONE,
            errorMessage: (failure as RemoteDataFailure).errorMessage),
        (result) {
      return state.copyWith(comment: result, commentPageIndex: 0);
    });
  }

  Stream<CommunityDetailState> _handleFetchMoreCommentResult(
      Either<Failure, List<CommentModel>> resultServer) async* {
    yield resultServer.fold(
        (failure) => state.copyWith(
            statusAPISubmit: StatusAPISubmit.NONE,
            isLoadingComments: false,
            errorMessage: (failure as RemoteDataFailure).errorMessage),
        (result) {
      ///increase index comment page when get more comments success
      if (result.isEmpty) {
        return state.copyWith(
          isLoadingComments: false,
        );
      }
      final comments = state.comment ?? [];
      comments.addAll(result);
      return state.copyWith(
          comment: comments,
          commentPageIndex: state.commentPageIndex + 1,
          isLoadingComments: false);
    });
  }

  Stream<CommunityDetailState> _handleFetchNewReplyResult(
      Either<Failure, List<CommentModel>> resultServer) async* {
    yield resultServer.fold(
        (failure) => state.copyWith(
            statusAPISubmit: StatusAPISubmit.NONE,
            errorMessage: (failure as RemoteDataFailure).errorMessage),
        (result) {
      state.commentReply.replied = result;
      return state.copyWith(commentPageIndex: 0);
    });
  }

  Stream<CommunityDetailState> _handleFetchMoreReplyResult(
      Either<Failure, List<CommentModel>> resultServer) async* {
    yield resultServer.fold(
        (failure) => state.copyWith(
            statusAPISubmit: StatusAPISubmit.NONE,
            isLoadingReplies: false,
            errorMessage: (failure as RemoteDataFailure).errorMessage),
        (result) {
      ///increase index reply page when get more reply success
      if (result.isEmpty) {
        return state.copyWith(
          isLoadingReplies: false,
        );
      }
      final replies = state.commentReply?.replied ?? [];
      replies.addAll(result);
      state.commentReply.replied = replies;
      return state.copyWith(
          isLoadingReplies: false, replyPageIndex: state.commentPageIndex + 1);
    });
  }

  Stream<CommunityDetailState> _handlePostAddCommentResult(
      Either<Failure, Success> resultServer) async* {
    yield resultServer.fold(
      (failure) => state.copyWith(
          statusAPISubmit: StatusAPISubmit.NONE,
          errorMessage: (failure as RemoteDataFailure).errorMessage),
      (result) =>
          state.copyWith(statusAPISubmit: StatusAPISubmit.ADD_COMMENT_SUCCESS),
    );
  }

  Stream<CommunityDetailState> _handlePostLikeCommentResult(
      Either<Failure, Success> resultServer) async* {
    yield resultServer.fold(
      (failure) => state.copyWith(
          statusAPISubmit: StatusAPISubmit.NONE,
          errorMessage: (failure as RemoteDataFailure).errorMessage),
      (result) =>
          state.copyWith(statusAPISubmit: StatusAPISubmit.LIKE_COMMENT_SUCCESS),
    );
  }

  Stream<CommunityDetailState> _handlePostReplyCommentResult(
      Either<Failure, Success> resultServer) async* {
    yield resultServer.fold(
      (failure) => state.copyWith(
          statusAPISubmit: StatusAPISubmit.NONE,
          errorMessage: (failure as RemoteDataFailure).errorMessage),
      (result) => state.copyWith(
          statusAPISubmit: StatusAPISubmit.REPLY_COMMENT_SUCCESS),
    );
  }

  @override
  void onTransition(
      Transition<CommunityDetailEvent, CommunityDetailState> transition) {
    // ignore: avoid_print
    print(transition);
    super.onTransition(transition);
  }
}

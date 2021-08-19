import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../utils/app_const.dart';
import '../../utils/location_wrapper.dart';
import '../../utils/utils.dart';

import '../model/comment_model.dart';
import '../model/places_model.dart';
import '../model/post_detail.dart';
import '../source/failure.dart';
import '../source/local/post_local_datasource.dart';
import '../source/remote/post_remote_data_source.dart';
import '../source/success.dart';
import 'repository.dart';

abstract class PostRepository {
  ///GET API
  Future<Either<Failure, PostDetail>> fetchPostDetail(String id);

  Future<Either<Failure, List<CommentModel>>> fetchPostComment(String id,
      {int pageIndex});

  Future<Either<Failure, List<CommentModel>>> fetchReplyComment(
      String postId, String commentId,
      {int pageIndex});

  ///POST API
  Future<Either<Failure, Success>> likeComment(
      String commentId, bool currentLike);

  Future<Either<Failure, Success>> addPostComment(
      String postId, String comment);

  Future<Either<Failure, Success>> addReplyComment(
      String postId, String commentId, String comment);

  Future<Either<Failure, Success>> removePostFromFeed(
      String postId, String action, String type);

  Future<Either<Failure, Success>> turnOffPostFromOwner(
      String postId, String action, String type);

  Future<Either<Failure, Success>> postCommunityPhoto(
      String caption, String assetId, String experience, List<int> image);

  Future<Either<Failure, Success>> postCommunityReview(String caption,
      String assetId, String experience, double rating, List<int> image);

  ///Local Data
  PostDetail getPostDetail(String postId);

  List<CommentModel> getPostComment(String postId);

  void savePostDetail(PostDetail postDetail);

  void savePostComment(String postId, List comments);
}

class PostRepositoryImpl extends Repository implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final LocationWrapper locationWrapper;
  final PostLocalDataSource localDataSrc;

  PostRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSrc,
    this.locationWrapper,
  });

  @override
  Future<Either<Failure, List<CommentModel>>> fetchPostComment(String id,
      {int pageIndex}) async {
    if (await networkInfo.isConnected) {
      try {
        final commentModel =
            await remoteDataSource.fetchPostComment(id, pageIndex: pageIndex);
        if (pageIndex == 0) {
          savePostComment(id, commentModel);
        }
        return Right(commentModel);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> fetchReplyComment(
      String postId, String commentId,
      {int pageIndex}) async {
    if (await networkInfo.isConnected) {
      try {
        final replies = await remoteDataSource
            .fetchReplyComment(postId, commentId, pageIndex: pageIndex);
        return Right(replies);
      } on RemoteDataFailure catch (e) {
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, PostDetail>> fetchPostDetail(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final postDetail = await remoteDataSource.fetchPostDetail(id);
        if (postDetail.place != null) {
          postDetail.place.eta = await _estimateTime(postDetail.place);
          postDetail.place.etaCar = await _estimateTimeCar(postDetail.place);
        }
        savePostDetail(postDetail);
        return Right(postDetail);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> addPostComment(
      String postId, String comment) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.addPostComment(postId, comment);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> addReplyComment(
      String postId, String commentId, String comment) async {
    if (await networkInfo.isConnected) {
      try {
        final success =
            await remoteDataSource.addReplyComment(postId, commentId, comment);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> likeComment(
      String commentId, bool currentLike) async {
    if (await networkInfo.isConnected) {
      try {
        final success =
            await remoteDataSource.likeComment(commentId, currentLike);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> removePostFromFeed(
      String postId, String action, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final success =
            await remoteDataSource.removePostFromFeed(postId, action, type);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> turnOffPostFromOwner(
      String postId, String action, String type) async {
    if (await networkInfo.isConnected) {
      try {
        final success =
            await remoteDataSource.turnOffPostFromOwner(postId, action, type);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> postCommunityPhoto(String caption,
      String assetId, String experience, List<int> image) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.postCommunityPhoto(
            caption, assetId, experience, image);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> postCommunityReview(String caption,
      String assetId, String experience, double rating, List<int> image) async {
    if (await networkInfo.isConnected) {
      try {
        final success = await remoteDataSource.postCommunityReview(
            caption, assetId, experience, rating, image);
        return Right(success);
      } on RemoteDataFailure catch (e) {
        // ignore: avoid_print
        print(e.errorMessage);
        return Left(e);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  // ignore: avoid_void_async
  void savePostComment(String postId, List comments) async {
    return localDataSrc.savePostComment(postId, comments);
  }

  @override
  List<CommentModel> getPostComment(String postId) {
    final commentModel = localDataSrc.getPostComment(postId);
    return commentModel;
  }

  @override
  void savePostDetail(PostDetail postDetail) {
    return localDataSrc.savePostDetail(postDetail);
  }

  @override
  PostDetail getPostDetail(String postId) {
    final postDetail = localDataSrc.getPostDetail(postId);
    return postDetail;
  }

  Future<String> _estimateTime(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTime(distance);
  }

  Future<String> _estimateTimeCar(PlaceModel place) async {
    final distance = await locationWrapper.calculateDistance(
        double.tryParse(
            place?.pickOneLocation?.lat ?? DEFAULT_LOCATION_LAT.toString()),
        double.tryParse(
            place?.pickOneLocation?.long ?? DEFAULT_LOCATION_LONG.toString()));
    return Utils.etaWalkingTimeCar(distance);
  }
}

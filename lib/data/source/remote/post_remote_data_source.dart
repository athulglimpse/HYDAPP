import '../../../common/localization/lang.dart';
import '../../../utils/data_form_util.dart';
import '../../model/comment_model.dart';
import '../../model/post_detail.dart';
import '../api_end_point.dart';
import '../failure.dart';
import '../success.dart';
import 'remote_base.dart';

abstract class PostRemoteDataSource {
  ///GET API
  Future<PostDetail> fetchPostDetail(String id);

  Future<List<CommentModel>> fetchPostComment(String id, {int pageIndex});

  Future<List<CommentModel>> fetchReplyComment(String postId, String commentId,
      {int pageIndex});

  ///POST API
  Future<Success> likeComment(String commentId, bool currentLike);

  Future<Success> addPostComment(String postId, String comment);

  Future<Success> addReplyComment(
      String postId, String commentId, String comment);

  Future<Success> removePostFromFeed(String postId, String action, String type);

  Future<Success> turnOffPostFromOwner(
      String postId, String action, String type);

  Future<Success> postCommunityPhoto(
      String caption, String assetId, String experience, List<int> image);

  Future<Success> postCommunityReview(String caption, String assetId,
      String experience, double rate, List<int> image);
}

class PostRemoteDataSourceImpl extends RemoteBaseImpl
    implements PostRemoteDataSource {
  PostRemoteDataSourceImpl();

  @override
  Future<PostDetail> fetchPostDetail(String id) async {
    setPrivateToken();

    final response = await dio
        .get(endPointGetCommunityDetail
            .format([id, DateTime.now().toIso8601String()]))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<PostDetail>(response, (responseData) {
      return PostDetail.fromJson(responseData.data);
    });
  }

  @override
  Future<List<CommentModel>> fetchReplyComment(String postId, String commentId,
      {int pageIndex}) async {
    setPrivateToken();

    final response = await dio
        .get(endPointGetReplies.format([
      postId,
      commentId,
      pageIndex.toString(),
      (DateTime.now().toIso8601String())
    ]))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<CommentModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data['result'];
      return strMap?.map((v) => CommentModel.fromJson(v))?.toList() ?? [];
    });
  }

  @override
  Future<List<CommentModel>> fetchPostComment(String id,
      {int pageIndex}) async {
    setPrivateToken();
    final response = await dio
        .get(endPointGetComments.format(
            [id, pageIndex.toString(), (DateTime.now().toIso8601String())]))
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<List<CommentModel>>(response, (responseData) {
      final List<dynamic> strMap = responseData.data['result'];
      return strMap.map((v) => CommentModel.fromJson(v)).toList();
    });
  }

  @override
  Future<Success> addPostComment(String postId, String comment) async {
    setPrivateToken();
    final data =
        DataFormUtil.addCommentFormData(postId: postId, comment: comment);
    final response =
        await dio.post(endPointAddComments, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> addReplyComment(
      String postId, String commentId, String comment) async {
    setPrivateToken();
    final data = DataFormUtil.replyCommentFormData(
        postId: postId, commentId: commentId, comment: comment);
    final response =
        await dio.post(endPointReplyComments, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> likeComment(String commentId, bool currentLike) async {
    setPrivateToken();
    final data = DataFormUtil.likeCommentFormData(
        id: commentId, currentLike: currentLike);
    final response =
        await dio.post(endPointLikeComments, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> removePostFromFeed(
      String postId, String action, String type) async {
    setPrivateToken();
    final data =
        DataFormUtil.postFormData(postId: postId, action: action, type: type);
    final response =
        await dio.post(endPointRemovePost, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> turnOffPostFromOwner(
      String postId, String action, String type) async {
    setPrivateToken();
    final data =
        DataFormUtil.postFormData(postId: postId, action: action, type: type);
    final response =
        await dio.post(endPointTurnOffPost, data: data).catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> postCommunityPhoto(String caption, String assetId,
      String experience, List<int> image) async {
    setPrivateToken();
    final data = DataFormUtil.postPhotoFormData(
        caption: caption,
        assetId: assetId,
        experience: experience,
        image: image);
    final response = await dio
        .post(endPointPostCommunityPhoto, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });
    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }

  @override
  Future<Success> postCommunityReview(String caption, String assetId,
      String experience, double rate, List<int> image) async {
    setPrivateToken();
    final data = DataFormUtil.postReviewFormData(
        caption: caption,
        assetId: assetId,
        rate: rate,
        experience: experience,
        image: image);
    final response = await dio
        .post(endPointPostCommunityReview, data: data)
        .catchError((error) {
      throw RemoteDataFailure(
          errorCode: error.toString(), errorMessage: error.toString());
    });

    return checkStatusCode<Success>(response, (responseData) {
      return Success();
    });
  }
}

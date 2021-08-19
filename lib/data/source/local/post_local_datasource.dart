import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/comment_model.dart';
import '../../model/post_detail.dart';
import 'prefs/app_preferences.dart';

abstract class PostLocalDataSource {
  PostDetail getPostDetail(String postId);
  List<CommentModel> getPostComment(String postId);

  void savePostDetail(PostDetail postDetail);

  void savePostComment(String postId, List<CommentModel> comments);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final AppPreferences appPreferences;

  PostLocalDataSourceImpl({@required this.appPreferences});

  @override
  List<CommentModel> getPostComment(String postId) {
    try {
      final jsonString = appPreferences.getPostComment(postId);
      if (jsonString != null) {
        final strMap = json.decode(jsonString);
        final List<dynamic> listComment =
            strMap.map((v) => CommentModel.fromJson(v)).toList();
        return listComment;
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  PostDetail getPostDetail(String postId) {
    try {
      final jsonString = appPreferences.getPostDetail(postId);
      if (jsonString != null) {
        return PostDetail.fromJson(json.decode(jsonString));
      } else {
        return null;
      }
    } on Exception catch (exception) {
      print(exception);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  void savePostComment(String postId, List<CommentModel> comments) {
    final str = comments.map((v) => v.toJson()).toList();
    return appPreferences.savePostComment(json.encode(str), postId);
  }

  @override
  void savePostDetail(PostDetail postDetail) {
    final postId = postDetail?.id.toString() ?? '';
    return appPreferences.savePostDetail(json.encode(postDetail), postId);
  }
}

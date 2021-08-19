import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uploader/flutter_uploader.dart';

import '../../common/di/injection/injector.dart';
import '../../utils/environment_info.dart';
import '../../utils/ui_util.dart';
import '../model/response_data.dart';
import '../model/update_model.dart';
import '../repository/help_report_repository.dart';
import '../repository/post_repository.dart';
import 'api_end_point.dart';
import 'failure.dart';
import 'remote/remote_base.dart';
import 'success.dart';

@immutable
class UploadPhotos {
  static const STREAM_KEY = 'stream';
  static const CANCEL_KEY = 'cancel';
  static const UPLOAD_MODEL_KEY = 'uploadModel';
  static const SEND_KEY = 'sent';
  static const TOTAL_KEY = 'total';
  static const FILE_KEY = 'file';
  static const IMAGE_ID_LIST_KEY = 'IMAGE_ID_LIST_KEY';

  final FlutterUploader uploader = FlutterUploader();
  final EnvironmentInfo _environmentInfo = sl<EnvironmentInfo>();
  final Map<String, Map> listUploadModel = {};

  StreamController<Map> getStreamByKey(String key) {
    if (!listUploadModel.containsKey(key)) {
      return null;
    }
    return listUploadModel[key][STREAM_KEY];
  }

  ///Get all upload streaming process
  List<StreamController<Map>> getAllStreams() {
    return listUploadModel
        .map((key, value) => value[STREAM_KEY])
        .values
        .toList();
  }

  /// init upload listener _ STEP 1
  void init() {
    uploader.progress.listen((event) {
      if ((listUploadModel[event.taskId]?.containsKey(STREAM_KEY)) ??
          false && listUploadModel[event.taskId][STREAM_KEY] != null) {
        listUploadModel[event.taskId][STREAM_KEY]
            .sink
            ?.add({SEND_KEY: event.progress, TOTAL_KEY: 100});
      }
    }); // unique tag for upload task

    uploader.result.listen((event) {
      if (event.status == UploadTaskStatus.failed) {
        listUploadModel.remove(event.taskId);
        UIUtil.showToast(event?.response ?? 'Upload Fail');
      } else {
        final responseData = ResponseData.fromJson(jsonDecode(event.response));

        ///Get Image Id from Response Data
        final imageId = int.parse(responseData.data['id']);
        // ignore: prefer_asserts_with_message
        assert(imageId is int);
        checkHasFileInQueue(
            event.taskId,
            listUploadModel[event.taskId][UPLOAD_MODEL_KEY],
            listUploadModel[event.taskId][STREAM_KEY],
            imageId);
      }
    });
  }

  ///Create tasks for upload file _ STEP 2
  Future<void> uploadFile(UploadModel uploadModel) async {
    if (uploadModel?.file?.isEmpty ?? true) {
      return;
    }
    if ((uploadModel?.file?.length ?? 0) > 0) {
      createUploadTask(uploadModel.file[0], uploadModel);
    }
  }

  String getUrl(TypePost type) {
    switch (type) {
      case TypePost.ADD_CHANGE_PROFILE_PHOTO:
        return endPointChangePhotoUser;
      case TypePost.ADD_REPORT_PHOTO:
        return endPointReportPhoto;
      default:
        return endPointUploadImage;
    }
  }

  ///Create task upload File  _ STEP 3
  ///
  ///File: file will upload
  ///Key: key to identify task
  ///
  // ignore: avoid_void_async
  void createUploadTask(File file, UploadModel uploadModel,
      {StreamController streamCon, List listImageIds}) async {
    final taskId = await uploader.enqueue(
      url: getUrl(uploadModel.typePost),
      //required: url to upload to
      files: [
        FileItem(
            filename: file?.path?.split('/')?.last,
            savedDir: file.parent.path,
            fieldname: FILE_KEY)
      ],
      data: uploadModel.typePost == TypePost.ADD_CHANGE_PROFILE_PHOTO
          ? {'field_name': 'user_picture'}
          : {},
      // required: list of files that you want to upload
      method: UploadMethod.POST,
      // HTTP method  (POST or PUT or PATCH)
      headers: {RemoteBaseImpl.X_CSRF_Token: _environmentInfo.accessToken},

      ///setup access_token
      showNotification: true,
    );

    listUploadModel[taskId] = {
      STREAM_KEY: streamCon ?? StreamController(),
      UPLOAD_MODEL_KEY: uploadModel,
      IMAGE_ID_LIST_KEY: listImageIds ?? [],
    };
  }

  /// Check has file in queue before do next step _ STEP 4
  /// Key: key to identify task
  void checkHasFileInQueue(String key, UploadModel uploadModel,
      StreamController streamController, int imageId) {
    if (listUploadModel.containsKey(key)) {
      ///Store Image Id to List
      listUploadModel[key][IMAGE_ID_LIST_KEY].add(imageId);

      uploadModel.file.removeAt(0);
      if (uploadModel.file.isEmpty) {
        ///If empty file to upload, close stream and submit final Step
        closeStreamAndRemove(key);
      } else {
        createUploadTask(uploadModel.file[0], uploadModel,
            streamCon: streamController,
            listImageIds: listUploadModel[key][IMAGE_ID_LIST_KEY]);

        listUploadModel.remove(key);
      }
    }
  }

  ///Close stream when finish task _ STEP 5
  void closeStreamAndRemove(String key) {
    if (listUploadModel.containsKey(key)) {
      ///Close Stream
      listUploadModel[key][STREAM_KEY]?.close();
      final UploadModel uploadModel = listUploadModel[key][UPLOAD_MODEL_KEY];
      final ids = <int>[];
      final List<dynamic> image =
          listUploadModel[key][IMAGE_ID_LIST_KEY].toList();
      image.forEach(ids.add);
      doFinalStep(uploadModel, ids);

      listUploadModel.remove(key);
    }
  }

  /// _ STEP 6
  Future<void> doFinalStep(UploadModel uploadModel, List<int> ids) async {
    final postRepository = sl<PostRepository>();
    final helpAndReportRepository = sl<HelpAndReportRepository>();
    switch (uploadModel.typePost) {
      case TypePost.ADD_COMMUNITY_POST_PHOTO:
        final result = await postRepository.postCommunityPhoto(
            uploadModel.postDataAfter['caption'],
            uploadModel.postDataAfter['asset_id'],
            uploadModel.postDataAfter['experience'],
            ids);
        _handleCommunityPostPhotoResult(result);
        break;
      case TypePost.ADD_COMMUNITY_WRITE_REVIEW:
        final result = await postRepository.postCommunityReview(
            uploadModel.postDataAfter['caption'],
            uploadModel.postDataAfter['asset_id'],
            uploadModel.postDataAfter['experience'],
            uploadModel.postDataAfter['rate'],
            ids);
        _handleCommunityPostPhotoResult(result);
        break;
      case TypePost.ADD_CHANGE_PROFILE_PHOTO:
        break;
      case TypePost.ADD_REPORT_PHOTO:
        final result = await helpAndReportRepository.sendReportItems(
            uploadModel.postDataAfter['description'],
            uploadModel.postDataAfter['issue_type'],
            ids);
        _handleCommunityPostPhotoResult(result);
        break;
      default:
        break;
    }
  }

  // ignore: always_declare_return_types
  _handleCommunityPostPhotoResult(
      Either<Failure, Success> resultServer) async* {
    yield resultServer.fold((failure) {
      UIUtil.showToast('Upload fail');
    }, (result) {
      UIUtil.showToast('Upload Success');
    });
  }
}

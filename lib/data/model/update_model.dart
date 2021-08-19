import 'dart:io';

import 'package:flutter/material.dart';

@immutable
class UploadModel {
  final List<File> file;
  final Map postDataAfter;
  final TypePost typePost;

  UploadModel({this.file, this.postDataAfter, this.typePost});

  ///
  ///  Files: list of file will upload
  ///  dataPost: the data will submit after upload success
  ///  endPoint: end point api for "dataPost"
  factory UploadModel.init({List<File> file, Map dataPost, TypePost typePost}) {
    print("dataPost dataPostdataPost " + dataPost.toString());
    return UploadModel(file: file, postDataAfter: dataPost, typePost: typePost);
  }
}

enum TypePost {
  ADD_COMMUNITY,
  ADD_COMMUNITY_POST_PHOTO,
  ADD_COMMUNITY_WRITE_REVIEW,
  ADD_CHANGE_PROFILE_PHOTO,
  ADD_REPORT_PHOTO,
}

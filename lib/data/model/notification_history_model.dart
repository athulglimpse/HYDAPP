import '../../utils/log_utils.dart';

import 'notification_data_model.dart';

class NotificationHistoryModel {
  int id;
  bool isNew;
  int datetime;
  String datetimeFormat;
  int uid;
  String type;
  String bundle;
  NotificationDataModel data;

  NotificationHistoryModel(
      {this.id,
      this.isNew,
      this.datetime,
      this.datetimeFormat,
      this.uid,
      this.type,
      this.bundle,
      this.data});

  NotificationHistoryModel.fromJson(Map<String, dynamic> json) {
    try{
      id = json['id'];
      isNew = json['is_new'];
      datetime = json['datetime'];
      datetimeFormat = json['datetime_format'];
      uid = json['uid'];
      type = json['type'];
      bundle = json['bundle'];
      data = json['data'] != null
          ? NotificationDataModel.fromJson(json['data'])
          : null;
    }catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_new'] = isNew;
    data['datetime'] = datetime;
    data['datetime_format'] = datetimeFormat;
    data['uid'] = uid;
    data['type'] = type;
    data['bundle'] = bundle;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

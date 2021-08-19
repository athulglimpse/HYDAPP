import '../../utils/log_utils.dart';

import 'image_info.dart';

class NotificationDataModel {
  int postId;
  int eventId;
  int amenityId;
  int commentId;
  String content;
  String status;
  ImageInfoData image;

  NotificationDataModel({
    this.postId,
    this.eventId,
    this.amenityId,
    this.commentId,
    this.content,
    this.status,
    this.image,
  });

  NotificationDataModel.fromJson(Map<String, dynamic> json) {
    try {
      postId = (json['post_id'] is int) ? json['post_id'] : 0;
      eventId = (json['event_id'] is int) ? json['event_id'] : 0;
      amenityId = (json['amenity_id'] is int) ? json['amenity_id'] : 0;
      commentId = (json['comment_id'] is int) ? json['comment_id'] : 0;
      content = json['content'];
      status = json['status'];
      if (json['image'] != null && json['image'] is Map) {
        image = ImageInfoData.fromJson(json['image']);
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['post_id'] = postId;
    data['event_id'] = eventId;
    data['amenity_id'] = amenityId;
    data['comment_id'] = commentId;
    data['content'] = content;
    data['status'] = status;
    if (image != null) {
      data['image'] = image.toJson();
    }

    return data;
  }
}

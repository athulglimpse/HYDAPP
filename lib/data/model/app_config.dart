import '../../utils/log_utils.dart';

class AppConfig {
  int defaultDistanceNearby;
  int appVersionCode;
  HelpMessageModel reportMessage;
  HelpMessageModel helpMessage;
  List<MaritalStatus> maritalStatus;
  String titleSocialMediaEn;
  String titleSocialMediaAr;
  String linkFacebook;
  String linkInstagram;
  String linkTwitter;

  AppConfig(
      {int appVersionCode,
      int defaultDistanceNearby,
      List<MaritalStatus> maritalStatus}) {
    defaultDistanceNearby = defaultDistanceNearby;
    appVersionCode = appVersionCode;
    maritalStatus = maritalStatus;
  }

  AppConfig.fromJson(Map<String, dynamic> json) {
    try {
      if (json['report_message'] != null) {
        reportMessage = HelpMessageModel.fromJson(json['report_message']);
      }
      if (json['help_message'] != null) {
        helpMessage = HelpMessageModel.fromJson(json['help_message']);
      }
      if (json['default_distance_nearby'] is int) {
        defaultDistanceNearby = json['default_distance_nearby'];
      }
      appVersionCode = json['app_version_code'];
      if (json['marital_status'] != null) {
        maritalStatus = <MaritalStatus>[];
        json['marital_status'].forEach((v) {
          maritalStatus.add(MaritalStatus.fromJson(v));
        });
      }
      if (json['title_social_media_en'] != null) {
        titleSocialMediaEn = json['title_social_media_en'];
      }
      if (json['title_social_media_ar'] != null) {
        titleSocialMediaAr = json['title_social_media_ar'];
      }
      if (json['link_facebook'] != null) {
        linkFacebook = json['link_facebook'];
      }
      if (json['link_instagram'] != null) {
        linkInstagram = json['link_instagram'];
      }
      if (json['link_twitter'] != null) {
        linkTwitter = json['link_twitter'];
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['default_distance_nearby'] = defaultDistanceNearby;
    data['help_message'] = helpMessage;
    data['report_message'] = reportMessage;
    data['app_version_code'] = appVersionCode;
    data['title_social_media_en'] = titleSocialMediaEn;
    data['title_social_media_ar'] = titleSocialMediaAr;
    data['link_facebook'] = linkFacebook;
    data['link_instagram'] = linkInstagram;
    data['link_twitter'] = linkFacebook;
    if (maritalStatus != null) {
      data['marital_status'] = maritalStatus.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// ignore: must_be_immutable
class MaritalStatus {
  int id;
  String nameEn;
  String nameAr;

  MaritalStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['name_en'];
    nameAr = json['name_ar'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    return data;
  }
}

class HelpMessageModel {
  String titleEn;
  String titleAr;
  String contentEn;
  String contentAr;

  HelpMessageModel.fromJson(Map<String, dynamic> json) {
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    contentEn = json['sub_title_en'];
    contentAr = json['sub_title_ar'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title_en'] = titleEn;
    data['title_ar'] = titleAr;
    data['sub_title_en'] = contentEn;
    data['sub_title_ar'] = contentAr;
    return data;
  }
}

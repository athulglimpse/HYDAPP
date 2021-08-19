import '../../utils/log_utils.dart';

import 'experience_model.dart';
import 'places_model.dart';

class AssetDetail extends PlaceModel {
  String shortDescription;
  String phoneNumber;
  String mailTo;
  String directUrl;
  String titleSocialMedia;
  String linkFacebook;
  String linkInstagram;
  String linkTwitter;
  ExperienceModel experience;

  AssetDetail(
      {String descriptions,
      ExperienceModel experiences,
      String phoneNumbers,
      String mails,
      String directUrls,
      String titleSocialMedias,
      String linkFacebooks,
      String linkInstagrams,
      String linkTwitters}) {
    description = descriptions;
    experience = experiences;
    phoneNumber = phoneNumbers;
    mailTo = mails;
    directUrl = directUrls;
    titleSocialMedia = titleSocialMedias;
    linkFacebook = linkFacebooks;
    linkInstagram = linkInstagrams;
    linkTwitter = linkTwitters;
  }

  AssetDetail.fromJson(Map<String, dynamic> json) {
    parseJson(json);
    try {
      shortDescription = json['short_description'];
      if (json['experience'] != null) {
        experience = ExperienceModel.fromJson(json['experience']);
      }
      phoneNumber = json['phone_number'];
      mailTo = json['mail_to'];
      directUrl = json['direct_url'];
      titleSocialMedia = json['title_social_media'];
      linkFacebook = json['link_facebook'];
      linkInstagram = json['link_instagram'];
      linkTwitter = json['link_twitter'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['short_description'] = shortDescription;
    data['experience'] = experience.toJson();
    data['note'] = note;
    data['phone_number'] = phoneNumber;
    data['mail_to'] = mailTo;
    data['direct_url'] = directUrl;
    data['title_social_media'] = titleSocialMedia;
    data['link_facebook'] = linkFacebook;
    data['link_instagram'] = linkInstagram;
    data['link_twitter'] = linkTwitter;
    return data;
  }
}

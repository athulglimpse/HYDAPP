import 'events.dart';

class EventDetailInfo extends EventInfo {
  String description;
  String directUrl;
  String titleSocialMedia;
  String linkFacebook;
  String linkInstagram;
  String linkTwitter;
  EventDetailInfo.fromJson(Map<String, dynamic> json) {
    final e = EventInfo.fromJson(json);
    copyModel(e);
    description = json['intro_description'];
    directUrl = json['direct_url'];
    titleSocialMedia = json['title_social_media'];
    linkFacebook = json['link_facebook'];
    linkInstagram = json['link_instagram'];
    linkTwitter = json['link_twitter'];
  }

  EventDetailInfo.fromModel(EventInfo e) {
    copyModel(e);
  }

  void copyModel(EventInfo e) {
    id = e.id;
    title = e.title;
    location = e.location;
    image = e.image;
    thumb = e.thumb;
    isFavorite = e.isFavorite;
    rate = e.rate;
    eventTime = e.eventTime;
    category = e.category;
    shareUrl = e.shareUrl;
    note = e.note;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['short_description'] = description;
    data['direct_url'] = directUrl;
    data['title_social_media'] = titleSocialMedia;
    data['link_facebook'] = linkFacebook;
    data['link_instagram'] = linkInstagram;
    data['link_twitter'] = linkTwitter;
    return data;
  }
}

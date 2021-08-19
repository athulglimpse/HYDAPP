import '../../utils/log_utils.dart';

import 'asset_detail.dart';
import 'image_info.dart';
import 'post_detail.dart';

class CommunityModel {
  List<CommunityPost> _trendingPost;
  List<CommunityPost> _allPost;

  CommunityModel({
    List<CommunityPost> trendingPost,
    List<CommunityPost> allPost,
  }) {
    _trendingPost = trendingPost;
    _allPost = allPost;
  }

  List<CommunityPost> get trendingPost => _trendingPost;
  set trendingPost(List<CommunityPost> trendingPost) =>
      _trendingPost = trendingPost;
  List<CommunityPost> get allPost => _allPost;
  set allPost(List<CommunityPost> allPost) => _allPost = allPost;

  CommunityModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['trending_post'] != null) {
        _trendingPost = <CommunityPost>[];
        json['trending_post'].forEach((v) {
          _trendingPost.add(CommunityPost.fromJson(v));
        });
      }
      if (json['all_post'] != null) {
        _allPost = <CommunityPost>[];
        json['all_post'].forEach((v) {
          _allPost.add(CommunityPost.fromJson(v));
        });
      }
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (_trendingPost != null) {
      data['trending_post'] = _trendingPost.map((v) => v.toJson()).toList();
    }
    if (_allPost != null) {
      data['all_post'] = _allPost.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunityPost {
  int id;
  Author author;
  String type;
  String caption;
  String category;
  String tagLocationId;
  bool isFavorite;
  String lat;
  String long;
  List<ImageInfoData> image;
  String url;
  String shareUrl;
  String rate;
  String review;
  AssetDetail place;

  CommunityPost({
    this.id,
    this.type,
    this.author,
    this.category,
    this.tagLocationId,
    this.isFavorite,
    this.caption,
    this.lat,
    this.long,
    this.image,
    this.url,
    this.rate,
    this.review,
  });

  CommunityPost.fromJson(Map<String, dynamic> json) {
    doParseFromJson(json);
  }

  void doParseFromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      tagLocationId = json['tag_location_id'];
      type = json['type'];
      shareUrl = json['share_url'];
      isFavorite = json['is_favorite'];
      caption = json['caption'];
      category = json['category'];
      author = json['author'] != null ? Author.fromJson(json['author']) : null;
      lat = json['lat'];
      long = json['long'];
      if (json['image'] != null && json['image'] is List) {
        image = <ImageInfoData>[];
        json['image'].forEach((v) {
          image.add(ImageInfoData.fromJson(v));
        });
      }
      if (json['place'] != null) {
        place = AssetDetail.fromJson(json['place']);
      }
      url = json['url'];
      rate = json['rate'];
      review = json['review'];
    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['is_favorite'] = isFavorite;
    data['share_url'] = shareUrl;
    data['tag_location_id'] = tagLocationId;
    if (place != null) {
      data['place'] = place.toJson();
    }
    if (author != null) {
      data['author'] = author.toJson();
    }
    data['category'] = category;
    data['caption'] = caption;
    data['lat'] = lat;
    data['long'] = long;
    if (image != null) {
      data['image'] = image.map((v) => v.toJson()).toList();
    }
    data['url'] = url;
    data['rate'] = rate;
    data['review'] = review;
    return data;
  }
}

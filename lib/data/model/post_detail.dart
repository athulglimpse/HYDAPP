import 'package:marvista/data/model/asset_detail.dart';

import '../../utils/log_utils.dart';

import 'community_model.dart';
import 'save_item_model.dart';

class PostDetail extends CommunityPost {
  List<Favourite> _favouriteList;

  PostDetail({List<Favourite> favouriteList}) {
    _favouriteList = favouriteList;
  }

  List<Favourite> get favouriteList => _favouriteList;

  set favouriteList(List<Favourite> favouriteList) =>
      _favouriteList = favouriteList;

  factory PostDetail.convertFromSaveItem(SaveItemModel itemModel) {
    final placeModel = PostDetail();
    placeModel.id = itemModel.id;
    placeModel.caption = itemModel.title;
    placeModel.image = itemModel.images;
    placeModel.isFavorite = itemModel.isFavorite;
    return placeModel;
  }

  PostDetail.fromJson(Map<String, dynamic> json) {
    doParseFromJson(json);
    try {
      if (json['favourite_list'] != null) {
        favouriteList = <Favourite>[];
        json['favourite_list'].forEach((v) {
          favouriteList.add(Favourite.fromJson(v));
        });
      }

    } catch (e, stacktrace) {
      LogUtils.d(e, stacktrace: stacktrace.toString());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    if (favouriteList != null) {
      data['favourite_list'] = favouriteList.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Author {
  int id;
  String photo;
  String username;

  Author({id, photo, username});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['photo'] = photo;
    data['username'] = username;
    return data;
  }
}

class Favourite {
  dynamic id;
  String photo;
  String username;

  Favourite({id, this.photo, this.username});

  Favourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['photo'] = photo;
    data['username'] = username;
    return data;
  }
}

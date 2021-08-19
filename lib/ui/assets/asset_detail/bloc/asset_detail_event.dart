part of 'asset_detail_bloc.dart';

@immutable
abstract class AssetDetailEvent {}

class CopyAssetDetail extends AssetDetailEvent {
  final PlaceModel placeModel;

  CopyAssetDetail(this.placeModel);
}

class FetchCommunityPost extends AssetDetailEvent {
  final String id;

  FetchCommunityPost({this.id});
}

class FetchAssetDetail extends AssetDetailEvent {
  final String id;

  FetchAssetDetail(this.id);
}

class AddFavorite extends AssetDetailEvent {
  final String id;

  AddFavorite(this.id);
}

class FetchAlsoLike extends AssetDetailEvent {
  final String id;

  FetchAlsoLike(this.id);
}

class AddPostFavorite extends AssetDetailEvent {
  final CommunityPost communityPost;

  AddPostFavorite(this.communityPost);
}

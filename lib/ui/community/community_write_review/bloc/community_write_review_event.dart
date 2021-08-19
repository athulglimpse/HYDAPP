part of 'community_write_review_bloc.dart';

@immutable
abstract class CommunityWriteReviewEvent {}

class AddImageWriteReview extends CommunityWriteReviewEvent {
  final List<String> path;

  AddImageWriteReview(this.path);
}

class FetchSuggestionsAmenities extends CommunityWriteReviewEvent {
  final String content;

  FetchSuggestionsAmenities(this.content);
}

class SubmitWriteReview extends CommunityWriteReviewEvent {
  final String caption;
  final String assetId;
  final double rate;
  final String experience;

  SubmitWriteReview(this.caption, this.assetId, this.rate, this.experience);
}

class DeleteImageWriteReview extends CommunityWriteReviewEvent {
  final String id;

  DeleteImageWriteReview(this.id);
}

class SelectedAssetDetail extends CommunityWriteReviewEvent {
  final AssetDetail assetDetail;

  SelectedAssetDetail(this.assetDetail);
}

class FocusFieldSearch extends CommunityWriteReviewEvent {
  final bool isFocusFieldSearch;
  FocusFieldSearch(this.isFocusFieldSearch);
}

class FetchAssetDetail extends CommunityWriteReviewEvent {
  final String id;

  FetchAssetDetail(this.id);
}

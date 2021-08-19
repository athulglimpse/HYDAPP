import 'package:json_annotation/json_annotation.dart';

import '../events.dart';
import '../places_model.dart';

part 'search_result_data_model.g.dart';

@JsonSerializable()
class SearchResultDataModel {
  SearchResultDataModel({
    this.events,
    this.amenities,
    // this.communities,
  });

  @JsonKey(name: 'events')
  final List<EventInfo> events;
  @JsonKey(name: 'amenities')
  final List<PlaceModel> amenities;
  // @JsonKey(name: 'communities')
  // List<EventInfo> communities;

  factory SearchResultDataModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultDataModelToJson(this);
}

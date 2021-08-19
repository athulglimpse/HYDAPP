import 'package:json_annotation/json_annotation.dart';

part 'recent_model.g.dart';

@JsonSerializable()
class RecentModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'content')
  final String content;
  @JsonKey(name: 'search_date_timestamp')
  final int search_date_timestamp;
  @JsonKey(name: 'search_date')
  final String search_date;
  @JsonKey(name: 'user_id')
  final int user_id;

  RecentModel({
    this.id,
    this.content,
    this.search_date_timestamp,
    this.search_date,
    this.user_id,
  });

  factory RecentModel.fromJson(Map<String, dynamic> json) =>
      _$RecentModelFromJson(json);
  Map<String, dynamic> toJson() => _$RecentModelToJson(this);
}

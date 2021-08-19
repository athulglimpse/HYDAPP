import 'package:json_annotation/json_annotation.dart';
part 'suitable_model.g.dart';
@JsonSerializable()
class SuitableModel{
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;

  SuitableModel({
    this.id,
    this.name,
  });

  factory SuitableModel.fromJson(Map<String, dynamic> json) =>
      _$SuitableModelFromJson(json);
  Map<String, dynamic> toJson() => _$SuitableModelToJson(this);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultDataModel _$SearchResultDataModelFromJson(
    Map<String, dynamic> json) {
  return SearchResultDataModel(
    events: (json['events'] as List)
        ?.map((e) =>
            e == null ? null : EventInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    amenities: (json['amenities'] as List)
        ?.map((e) =>
            e == null ? null : PlaceModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SearchResultDataModelToJson(
        SearchResultDataModel instance) =>
    <String, dynamic>{
      'events': instance.events,
      'amenities': instance.amenities,
    };

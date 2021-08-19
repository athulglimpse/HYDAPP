// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) {
  return LocationModel(
    id: json['id'] as int,
    locationAt: json['location_at'] as String,
    lat: json['lat'] as String,
    long: json['long'] as String,
    address: json['address'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'long': instance.long,
      'location_at': instance.locationAt,
      'address': instance.address,
      'title': instance.title,
    };

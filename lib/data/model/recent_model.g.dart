// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecentModel _$RecentModelFromJson(Map<String, dynamic> json) {
  return RecentModel(
    id: json['id'] as int,
    content: json['content'] as String,
    search_date_timestamp: json['search_date_timestamp'] as int,
    search_date: json['search_date'] as String,
    user_id: json['user_id'] as int,
  );
}

Map<String, dynamic> _$RecentModelToJson(RecentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'search_date_timestamp': instance.search_date_timestamp,
      'search_date': instance.search_date,
      'user_id': instance.user_id,
    };

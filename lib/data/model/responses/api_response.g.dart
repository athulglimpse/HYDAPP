// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(Map<String, dynamic> json) {
  return ApiResponse<T>(
    json['status'] as int,
    _Converter<T>().fromJson(json['data']),
  );
}

Map<String, dynamic> _$ApiResponseToJson<T>(ApiResponse<T> instance) {
  final val = <String, dynamic>{
    'status': instance.status,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('data', _Converter<T>().toJson(instance.data));
  return val;
}

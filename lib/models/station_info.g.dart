// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationInfo _$StationInfoFromJson(Map<String, dynamic> json) => StationInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  code: json['code'] as String,
  city: City.fromJson(json['city'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StationInfoToJson(StationInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'city': instance.city,
    };

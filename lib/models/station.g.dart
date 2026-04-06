// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station(
  id: json['id'] as String,
  name: json['name'] as String,
  code: json['code'] as String,
  city: City.fromJson(json['city'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'code': instance.code,
  'city': instance.city,
};

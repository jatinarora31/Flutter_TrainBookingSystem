// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
  id: json['id'] as String,
  state: json['state'] as String,
  country: json['country'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'state': instance.state,
  'country': instance.country,
};

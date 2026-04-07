// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
  id: json['id'] as String,
  stopOrder: (json['stop_order'] as num).toInt(),
  arrivalTime: json['arrival_time'] == null
      ? null
      : DateTime.parse(json['arrival_time'] as String),
  departureTime: json['departure_time'] == null
      ? null
      : DateTime.parse(json['departure_time'] as String),
  distanceFromOriginKm: (json['distance_from_origin_km'] as num).toDouble(),
  station: StationInfo.fromJson(json['station'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
  'id': instance.id,
  'stop_order': instance.stopOrder,
  'arrival_time': instance.arrivalTime?.toIso8601String(),
  'departure_time': instance.departureTime?.toIso8601String(),
  'distance_from_origin_km': instance.distanceFromOriginKm,
  'station': instance.station,
};

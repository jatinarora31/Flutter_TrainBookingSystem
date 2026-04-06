// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stop _$StopFromJson(Map<String, dynamic> json) => Stop(
  id: json['id'] as String,
  trainId: json['trainId'] as String,
  stationId: json['stationId'] as String,
  stopOrder: (json['stopOrder'] as num).toInt(),
  arrivalTime: json['arrivalTime'] == null
      ? null
      : DateTime.parse(json['arrivalTime'] as String),
  departureTime: json['departureTime'] == null
      ? null
      : DateTime.parse(json['departureTime'] as String),
  distanceFromOriginKm: (json['distanceFromOriginKm'] as num).toDouble(),
  station: StationInfo.fromJson(json['station'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StopToJson(Stop instance) => <String, dynamic>{
  'id': instance.id,
  'trainId': instance.trainId,
  'stationId': instance.stationId,
  'stopOrder': instance.stopOrder,
  'arrivalTime': instance.arrivalTime?.toIso8601String(),
  'departureTime': instance.departureTime?.toIso8601String(),
  'distanceFromOriginKm': instance.distanceFromOriginKm,
  'station': instance.station,
};

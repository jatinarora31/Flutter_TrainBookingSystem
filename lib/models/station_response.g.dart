// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationResponse _$StationResponseFromJson(Map<String, dynamic> json) =>
    StationResponse(
      stations: (json['data'] as List<dynamic>?)
          ?.map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StationResponseToJson(StationResponse instance) =>
    <String, dynamic>{'data': instance.stations};

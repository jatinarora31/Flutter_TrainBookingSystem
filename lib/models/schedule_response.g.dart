// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      travelDate: json['travel_date'] as String,
      dstStationId: json['dst_station_id'] as String,
      srcStationId: json['src_station_id'] as String,
      schedules: (json['schedules'] as List<dynamic>)
          .map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'travel_date': instance.travelDate,
      'src_station_id': instance.srcStationId,
      'dst_station_id': instance.dstStationId,
      'schedules': instance.schedules,
    };

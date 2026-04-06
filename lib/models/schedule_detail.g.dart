// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDetail _$ScheduleDetailFromJson(Map<String, dynamic> json) =>
    ScheduleDetail(
      schedule: ScheduleInfo.fromJson(json['schedule'] as Map<String, dynamic>),
      stops: (json['stops'] as List<dynamic>)
          .map((e) => Stop.fromJson(e as Map<String, dynamic>))
          .toList(),
      coaches: (json['coaches'] as List<dynamic>)
          .map((e) => Coach.fromJson(e as Map<String, dynamic>))
          .toList(),
      availability: Availability.fromJson(
        json['availability'] as Map<String, dynamic>,
      ),
      fareOptions: FareOptions.fromJson(
        json['fare_options'] as Map<String, dynamic>,
      ),
      seatMap: SeatMap.fromJson(json['seat_map'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleDetailToJson(ScheduleDetail instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
      'stops': instance.stops,
      'coaches': instance.coaches,
      'availability': instance.availability,
      'fare_options': instance.fareOptions,
      'seat_map': instance.seatMap,
    };

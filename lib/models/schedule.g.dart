// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  id: json['id'] as String,
  travelDate: json['travel_date'] as String,
  departureTime: Schedule._dateTimeFromString(json['departure_time'] as String),
  expectedArrivalTime: Schedule._dateTimeFromString(
    json['expected_arrival_time'] as String,
  ),
  status: json['status'] as String,
  train: Train.fromJson(json['train'] as Map<String, dynamic>),
  availability: Availability.fromJson(
    json['availability'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'travel_date': instance.travelDate,
  'departure_time': Schedule._dateTimeToString(instance.departureTime),
  'expected_arrival_time': Schedule._dateTimeToString(
    instance.expectedArrivalTime,
  ),
  'status': instance.status,
  'train': instance.train,
  'availability': instance.availability,
};

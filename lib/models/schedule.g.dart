// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  id: json['id'] as String,
  trainId: json['train_id'] as String,
  travelDate: DateTime.parse(json['travel_date'] as String),
  delayMinutes: (json['delay_minutes'] as num).toInt(),
  departureTime: DateTime.parse(json['departure_time'] as String),
  expectedArrivalTime: DateTime.parse(json['expected_arrival_time'] as String),
  status: json['status'] as String,
  train: Train.fromJson(json['train'] as Map<String, dynamic>),
  availability: Availability.fromJson(
    json['availability'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'train_id': instance.trainId,
  'travel_date': instance.travelDate.toIso8601String(),
  'departure_time': instance.departureTime.toIso8601String(),
  'expected_arrival_time': instance.expectedArrivalTime.toIso8601String(),
  'status': instance.status,
  'delay_minutes': instance.delayMinutes,
  'train': instance.train,
  'availability': instance.availability,
};

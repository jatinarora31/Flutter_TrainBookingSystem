// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleInfo _$ScheduleInfoFromJson(Map<String, dynamic> json) => ScheduleInfo(
  id: json['id'] as String,
  trainId: json['train_id'] as String,
  travelDate: json['travel_date'] as String,
  departureTime: json['departure_time'] == null
      ? null
      : DateTime.parse(json['departure_time'] as String),
  expectedArrivalTime: json['expected_arrival_time'] == null
      ? null
      : DateTime.parse(json['expected_arrival_time'] as String),
  status: json['status'] as String,
  delayMinutes: (json['delay_minutes'] as num).toInt(),
  train: TrainInfo.fromJson(json['train'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduleInfoToJson(ScheduleInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'train_id': instance.trainId,
      'travel_date': instance.travelDate,
      'departure_time': instance.departureTime?.toIso8601String(),
      'expected_arrival_time': instance.expectedArrivalTime?.toIso8601String(),
      'status': instance.status,
      'delay_minutes': instance.delayMinutes,
      'train': instance.train,
    };

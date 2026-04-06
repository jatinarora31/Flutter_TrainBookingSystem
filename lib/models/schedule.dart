import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/availability.dart';
import 'package:quick_ticket/models/train.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final String id;

  @JsonKey(name: 'train_id')
  final String trainId;

  @JsonKey(name: 'travel_date')
  final DateTime travelDate;

  @JsonKey(name: 'departure_time')
  final DateTime departureTime;

  @JsonKey(name: 'expected_arrival_time')
  final DateTime expectedArrivalTime;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'delay_minutes')
  final int delayMinutes;

  @JsonKey(name: 'train')
  final Train train;

  final Availability availability;

  Schedule({
    required this.id,
    required this.trainId,
    required this.travelDate,
    required this.delayMinutes,
    required this.departureTime,
    required this.expectedArrivalTime,
    required this.status,
    required this.train,
    required this.availability
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  String get formattedDeparture =>
      '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}';

  String get formattedArrival =>
      '${expectedArrivalTime.hour.toString().padLeft(2, '0')}:${expectedArrivalTime.minute.toString().padLeft(2, '0')}';

  String get duration {
    final diff = expectedArrivalTime.difference(departureTime);
    return '${diff.inHours}h ${diff.inMinutes % 60}m';
  }

}
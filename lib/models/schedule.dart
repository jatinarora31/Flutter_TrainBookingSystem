import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/availability.dart';
import 'package:quick_ticket/models/train.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  final String id;

  @JsonKey(name: 'travel_date')
  final String travelDate;

  @JsonKey(
    name: 'departure_time',
    fromJson: _dateTimeFromString,
    toJson: _dateTimeToString,
  )
  final DateTime departureTime;

  @JsonKey(
    name: 'expected_arrival_time',
    fromJson: _dateTimeFromString,
    toJson: _dateTimeToString,
  )
  final DateTime expectedArrivalTime;

  final String status;

  final Train train;
  final Availability availability;

  Schedule({
    required this.id,
    required this.travelDate,
    required this.departureTime,
    required this.expectedArrivalTime,
    required this.status,
    required this.train,
    required this.availability,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  static DateTime _dateTimeFromString(String date) => DateTime.parse(date);
  static String _dateTimeToString(DateTime date) => date.toIso8601String();

  String get formattedDeparture =>
      '${departureTime.hour.toString().padLeft(2, '0')}:${departureTime.minute.toString().padLeft(2, '0')}';

  String get formattedArrival =>
      '${expectedArrivalTime.hour.toString().padLeft(2, '0')}:${expectedArrivalTime.minute.toString().padLeft(2, '0')}';

  String get duration {
    final diff = expectedArrivalTime.difference(departureTime);
    return '${diff.inHours}h ${diff.inMinutes % 60}m';
  }
}
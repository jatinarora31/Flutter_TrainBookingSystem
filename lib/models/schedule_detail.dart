import 'package:QuickTicket/models/schedule_info.dart';
import 'package:QuickTicket/models/seat_map.dart';
import 'package:QuickTicket/models/stop.dart';
import 'package:json_annotation/json_annotation.dart';
import 'availability.dart';
import 'coach.dart';
import 'fare.dart';

part 'schedule_detail.g.dart';

@JsonSerializable()
class ScheduleDetail {
  final ScheduleInfo schedule;
  final List<Stop> stops;
  final List<Coach> coaches;
  final Availability availability;

  @JsonKey(name: 'fare_options')
  final FareOptions fareOptions;

  @JsonKey(name: 'seat_map')
  final SeatMap seatMap;

  ScheduleDetail({
    required this.schedule,
    required this.stops,
    required this.coaches,
    required this.availability,
    required this.fareOptions,
    required this.seatMap,
  });

  factory ScheduleDetail.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDetailToJson(this);
}









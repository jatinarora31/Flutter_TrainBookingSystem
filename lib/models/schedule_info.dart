import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/train_info.dart';

part 'schedule_info.g.dart';

@JsonSerializable()
class ScheduleInfo {
  final String id;
  // @JsonKey(name: 'train_id')
  // final String? trainId;
  @JsonKey(name: 'travel_date')
  final String travelDate;
  @JsonKey(name: 'departure_time')
  final DateTime? departureTime;
  @JsonKey(name: 'expected_arrival_time')
  final DateTime? expectedArrivalTime;
  final String status;
  @JsonKey(name: 'delay_minutes', defaultValue: 0)
  final int delayMinutes;
  final TrainInfo train;

  ScheduleInfo({
    required this.id,
    required this.travelDate,
    required this.departureTime,
    required this.expectedArrivalTime,
    required this.status,
    required this.delayMinutes,
    required this.train,
  });

  factory ScheduleInfo.fromJson(Map<String, dynamic> json) =>
      _$ScheduleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleInfoToJson(this);
}
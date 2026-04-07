import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/schedule.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleResponse {
  @JsonKey(name: 'data')
  final List<Schedule> schedules;

  ScheduleResponse({
    required this.schedules
  });

  factory ScheduleResponse.fromJson(Map<String,dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String,dynamic> toJson() => _$ScheduleResponseToJson(this);

}
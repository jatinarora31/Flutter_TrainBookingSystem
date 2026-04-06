import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/schedule.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleResponse {

  @JsonKey(name: 'travel_date')
  final String travelDate;

  @JsonKey(name: 'src_station_id')
  final String srcStationId;

  @JsonKey(name: 'dst_station_id')
  final String dstStationId;

  @JsonKey(name: 'schedules')
  final List<Schedule> schedules;

  ScheduleResponse({
    required this.travelDate,
    required this.dstStationId,
    required this.srcStationId,
    required this.schedules
  });

  factory ScheduleResponse.fromJson(Map<String,dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String,dynamic> toJson() => _$ScheduleResponseToJson(this);

}
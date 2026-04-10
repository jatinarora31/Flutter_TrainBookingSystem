import 'package:QuickTicket/models/schedule_detail.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule_data.g.dart';

@JsonSerializable()
class ScheduleData {
  final ScheduleDetail schedule;

  ScheduleData({required this.schedule});

  factory ScheduleData.fromJson(Map<String,dynamic> json) =>
      _$ScheduleDataFromJson(json);

}
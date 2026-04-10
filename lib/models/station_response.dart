import 'package:json_annotation/json_annotation.dart';
import 'package:QuickTicket/models/station.dart';

part 'station_response.g.dart';

@JsonSerializable()
class StationResponse {

  @JsonKey(name:'data')
  final List<Station>? stations;

  StationResponse({required this.stations});

  factory StationResponse.fromJson(Map<String,dynamic> json) =>
      _$StationResponseFromJson(json);

}
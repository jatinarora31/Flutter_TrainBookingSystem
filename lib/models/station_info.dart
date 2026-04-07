import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'station_info.g.dart';

@JsonSerializable()
class StationInfo {
  final String id;
  final String name;
  final String code;
  final City city;

  StationInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
  });

  factory StationInfo.fromJson(Map<String, dynamic> json) =>
      _$StationInfoFromJson(json);
}
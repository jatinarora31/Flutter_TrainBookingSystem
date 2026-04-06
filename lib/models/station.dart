
import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'station.g.dart';

@JsonSerializable()
class Station {
  final String id;
  final String name;
  final String code;
  final City city;

  Station({
    required this.id,
    required this.name,
    required this.code,
    required this.city,
  });

  factory Station.fromJson(Map<String,dynamic> json) =>
      _$StationFromJson(json);

}
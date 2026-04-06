import 'package:json_annotation/json_annotation.dart';

part 'station_info.g.dart';

@JsonSerializable()
class StationInfo {
  final String id;
  final String name;
  final String code;

  StationInfo({required this.id, required this.name, required this.code});

  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}
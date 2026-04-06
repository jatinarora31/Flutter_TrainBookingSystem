import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  final String id;
  final String name;
  final String state;
  final String country;

  City({
    required this.id,
    required this.state,
    required this.country,
    required this.name
  });

  factory City.fromJson(Map<String,dynamic> json) =>
      _$CityFromJson(json);

}

import 'package:json_annotation/json_annotation.dart';

part 'train.g.dart';

@JsonSerializable()
class Train {

  final String id;

  @JsonKey(name: 'train_number')
  final String trainNumber;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'train_type')
  final String trainType;
  final String rating;
  final String grade;

  Train({
    required this.id,
    required this.trainNumber,
    required this.name,
    required this.trainType,
    required this.rating,
    required this.grade,
  });

  factory Train.fromJson(Map<String, dynamic> json) =>
      _$TrainFromJson(json);

  Map<String, dynamic> toJson() => _$TrainToJson(this);

}
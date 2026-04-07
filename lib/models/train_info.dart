import 'package:json_annotation/json_annotation.dart';

part 'train_info.g.dart';

@JsonSerializable()
class TrainInfo {
  final String id;
  @JsonKey(name: 'train_number')
  final String trainNumber;
  final String name;
  @JsonKey(name: 'train_type')
  final String trainType;
  final String? rating;
  final String? grade;

  TrainInfo({
    required this.id,
    required this.trainNumber,
    required this.name,
    required this.trainType,
    this.rating,
    this.grade,
  });

  factory TrainInfo.fromJson(Map<String, dynamic> json) =>
      _$TrainInfoFromJson(json);
}
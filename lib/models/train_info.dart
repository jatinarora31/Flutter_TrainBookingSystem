
import 'package:json_annotation/json_annotation.dart';

part 'train_info.g.dart';

@JsonSerializable()
class TrainInfo {
  final String id;
  final String trainNumber;
  final String name;
  final String trainType;

  TrainInfo({
    required this.id,
    required this.trainNumber,
    required this.name,
    required this.trainType,
  });

  factory TrainInfo.fromJson(Map<String, dynamic> json) {
    return TrainInfo(
      id: json['id'] ?? '',
      trainNumber: json['train_number'] ?? '',
      name: json['name'] ?? '',
      trainType: json['train_type'] ?? '',
    );
  }
}
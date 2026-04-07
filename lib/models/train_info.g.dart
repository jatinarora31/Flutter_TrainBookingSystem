// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainInfo _$TrainInfoFromJson(Map<String, dynamic> json) => TrainInfo(
  id: json['id'] as String,
  trainNumber: json['train_number'] as String,
  name: json['name'] as String,
  trainType: json['train_type'] as String,
  rating: json['rating'] as String?,
  grade: json['grade'] as String?,
);

Map<String, dynamic> _$TrainInfoToJson(TrainInfo instance) => <String, dynamic>{
  'id': instance.id,
  'train_number': instance.trainNumber,
  'name': instance.name,
  'train_type': instance.trainType,
  'rating': instance.rating,
  'grade': instance.grade,
};

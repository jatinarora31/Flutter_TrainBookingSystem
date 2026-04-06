// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Train _$TrainFromJson(Map<String, dynamic> json) => Train(
  id: json['id'] as String,
  trainNumber: json['train_number'] as String,
  name: json['name'] as String,
  trainType: json['train_type'] as String,
);

Map<String, dynamic> _$TrainToJson(Train instance) => <String, dynamic>{
  'id': instance.id,
  'train_number': instance.trainNumber,
  'name': instance.name,
  'train_type': instance.trainType,
};

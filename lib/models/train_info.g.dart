// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'train_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainInfo _$TrainInfoFromJson(Map<String, dynamic> json) => TrainInfo(
  id: json['id'] as String,
  trainNumber: json['trainNumber'] as String,
  name: json['name'] as String,
  trainType: json['trainType'] as String,
);

Map<String, dynamic> _$TrainInfoToJson(TrainInfo instance) => <String, dynamic>{
  'id': instance.id,
  'trainNumber': instance.trainNumber,
  'name': instance.name,
  'trainType': instance.trainType,
};

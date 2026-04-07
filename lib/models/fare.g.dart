// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOptions _$FareOptionsFromJson(Map<String, dynamic> json) => FareOptions(
  oneAc: json['1ac'] == null
      ? null
      : FareDetail.fromJson(json['1ac'] as Map<String, dynamic>),
  twoAc: json['2ac'] == null
      ? null
      : FareDetail.fromJson(json['2ac'] as Map<String, dynamic>),
  sleeper: json['sleeper'] == null
      ? null
      : FareDetail.fromJson(json['sleeper'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FareOptionsToJson(FareOptions instance) =>
    <String, dynamic>{
      '1ac': instance.oneAc,
      '2ac': instance.twoAc,
      'sleeper': instance.sleeper,
    };

FareDetail _$FareDetailFromJson(Map<String, dynamic> json) =>
    FareDetail(farePerSeat: json['fare_per_seat'] as String);

Map<String, dynamic> _$FareDetailToJson(FareDetail instance) =>
    <String, dynamic>{'fare_per_seat': instance.farePerSeat};

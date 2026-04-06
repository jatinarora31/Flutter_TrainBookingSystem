// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOptions _$FareOptionsFromJson(Map<String, dynamic> json) => FareOptions(
  sleeper: json['sleeper'] == null
      ? null
      : FareInfo.fromJson(json['sleeper'] as Map<String, dynamic>),
  oneAc: json['oneAc'] == null
      ? null
      : FareInfo.fromJson(json['oneAc'] as Map<String, dynamic>),
  twoAc: json['twoAc'] == null
      ? null
      : FareInfo.fromJson(json['twoAc'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FareOptionsToJson(FareOptions instance) =>
    <String, dynamic>{
      'sleeper': instance.sleeper,
      'oneAc': instance.oneAc,
      'twoAc': instance.twoAc,
    };

FareInfo _$FareInfoFromJson(Map<String, dynamic> json) => FareInfo(
  farePerSeat: (json['farePerSeat'] as num).toDouble(),
  distanceKm: (json['distanceKm'] as num).toInt(),
);

Map<String, dynamic> _$FareInfoToJson(FareInfo instance) => <String, dynamic>{
  'farePerSeat': instance.farePerSeat,
  'distanceKm': instance.distanceKm,
};

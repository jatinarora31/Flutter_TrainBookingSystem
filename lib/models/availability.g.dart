// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Availability _$AvailabilityFromJson(Map<String, dynamic> json) => Availability(
  availableSeats: (json['available_seats'] as num).toInt(),
  coachTypeAvailability: CoachTypeGroup.fromJson(
    json['coach_type_availability'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AvailabilityToJson(Availability instance) =>
    <String, dynamic>{
      'available_seats': instance.availableSeats,
      'coach_type_availability': instance.coachTypeAvailability,
    };

CoachTypeGroup _$CoachTypeGroupFromJson(
  Map<String, dynamic> json,
) => CoachTypeGroup(
  oneAc: CoachTypeAvailability.fromJson(json['one_ac'] as Map<String, dynamic>),
  twoAc: CoachTypeAvailability.fromJson(json['two_ac'] as Map<String, dynamic>),
  sleeper: CoachTypeAvailability.fromJson(
    json['sleeper'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CoachTypeGroupToJson(CoachTypeGroup instance) =>
    <String, dynamic>{
      'one_ac': instance.oneAc,
      'two_ac': instance.twoAc,
      'sleeper': instance.sleeper,
    };

CoachTypeAvailability _$CoachTypeAvailabilityFromJson(
  Map<String, dynamic> json,
) => CoachTypeAvailability(
  totalActiveSeats: (json['total_active_seats'] as num).toInt(),
  availableSeats: (json['available_seats'] as num).toInt(),
);

Map<String, dynamic> _$CoachTypeAvailabilityToJson(
  CoachTypeAvailability instance,
) => <String, dynamic>{
  'total_active_seats': instance.totalActiveSeats,
  'available_seats': instance.availableSeats,
};

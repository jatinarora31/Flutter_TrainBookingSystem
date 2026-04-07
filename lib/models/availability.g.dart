// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Availability _$AvailabilityFromJson(Map<String, dynamic> json) => Availability(
  availableSeats: (json['available_seats'] as num).toInt(),
  coachTypeAvailability: CoachTypeAvailability.fromJson(
    json['coach_type_availability'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AvailabilityToJson(Availability instance) =>
    <String, dynamic>{
      'available_seats': instance.availableSeats,
      'coach_type_availability': instance.coachTypeAvailability,
    };

CoachTypeAvailability _$CoachTypeAvailabilityFromJson(
  Map<String, dynamic> json,
) => CoachTypeAvailability(
  oneAc: CoachAvailability.fromJson(json['1ac'] as Map<String, dynamic>),
  sleeper: CoachAvailability.fromJson(json['sleeper'] as Map<String, dynamic>),
  twoAc: CoachAvailability.fromJson(json['2ac'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoachTypeAvailabilityToJson(
  CoachTypeAvailability instance,
) => <String, dynamic>{
  '1ac': instance.oneAc,
  'sleeper': instance.sleeper,
  '2ac': instance.twoAc,
};

CoachAvailability _$CoachAvailabilityFromJson(Map<String, dynamic> json) =>
    CoachAvailability(
      totalActiveSeats: (json['total_active_seats'] as num).toInt(),
      availableSeats: (json['available_seats'] as num).toInt(),
    );

Map<String, dynamic> _$CoachAvailabilityToJson(CoachAvailability instance) =>
    <String, dynamic>{
      'total_active_seats': instance.totalActiveSeats,
      'available_seats': instance.availableSeats,
    };

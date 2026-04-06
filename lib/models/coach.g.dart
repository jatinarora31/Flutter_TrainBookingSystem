// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coach _$CoachFromJson(Map<String, dynamic> json) => Coach(
  id: json['id'] as String,
  coachNumber: json['coachNumber'] as String,
  coachType: json['coachType'] as String,
  totalSeats: (json['totalSeats'] as num).toInt(),
  seats: (json['seats'] as List<dynamic>)
      .map((e) => Seat.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CoachToJson(Coach instance) => <String, dynamic>{
  'id': instance.id,
  'coachNumber': instance.coachNumber,
  'coachType': instance.coachType,
  'totalSeats': instance.totalSeats,
  'seats': instance.seats,
};

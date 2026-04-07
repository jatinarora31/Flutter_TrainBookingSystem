// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coach _$CoachFromJson(Map<String, dynamic> json) => Coach(
  id: json['id'] as String,
  trainId: json['train_id'] as String,
  coachNumber: json['coach_number'] as String,
  coachType: json['coach_type'] as String,
  totalSeats: (json['total_seats'] as num).toInt(),
  seats: (json['seats'] as List<dynamic>)
      .map((e) => Seat.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CoachToJson(Coach instance) => <String, dynamic>{
  'id': instance.id,
  'train_id': instance.trainId,
  'coach_number': instance.coachNumber,
  'coach_type': instance.coachType,
  'total_seats': instance.totalSeats,
  'seats': instance.seats,
};

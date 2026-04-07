// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: json['id'] as String,
  coachId: json['coach_id'] as String,
  seatNumber: json['seat_number'] as String,
  seatType: json['seat_type'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'coach_id': instance.coachId,
  'seat_number': instance.seatNumber,
  'seat_type': instance.seatType,
  'is_active': instance.isActive,
};

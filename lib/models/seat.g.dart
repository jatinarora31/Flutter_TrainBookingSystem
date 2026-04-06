// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
  id: json['id'] as String,
  seatNumber: json['seatNumber'] as String,
  seatType: json['seatType'] as String,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
  'id': instance.id,
  'seatNumber': instance.seatNumber,
  'seatType': instance.seatType,
  'isActive': instance.isActive,
};

SeatMap _$SeatMapFromJson(Map<String, dynamic> json) => SeatMap(
  unavailableSeatIds: (json['unavailableSeatIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$SeatMapToJson(SeatMap instance) => <String, dynamic>{
  'unavailableSeatIds': instance.unavailableSeatIds,
};

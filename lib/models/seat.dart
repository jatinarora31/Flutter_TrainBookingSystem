import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final String id;
  @JsonKey(name: 'coach_id')
  final String coachId;
  @JsonKey(name: 'seat_number')
  final String seatNumber;
  @JsonKey(name: 'seat_type')
  final String seatType;
  @JsonKey(name: 'is_active')
  final bool isActive;

  Seat({
    required this.id,
    required this.coachId,
    required this.seatNumber,
    required this.seatType,
    required this.isActive,
  });

  factory Seat.fromJson(Map<String, dynamic> json) =>
      _$SeatFromJson(json);
}
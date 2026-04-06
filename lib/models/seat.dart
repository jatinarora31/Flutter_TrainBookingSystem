import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

@JsonSerializable()
class Seat {
  final String id;
  final String seatNumber;
  final String seatType;
  final bool isActive;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.seatType,
    required this.isActive,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      seatNumber: json['seat_number'],
      seatType: json['seat_type'],
      isActive: json['is_active'],
    );
  }
}

@JsonSerializable()
class SeatMap {
  final List<String> unavailableSeatIds;

  SeatMap({required this.unavailableSeatIds});

  factory SeatMap.fromJson(Map<String, dynamic> json) {
    return SeatMap(
      unavailableSeatIds:
      List<String>.from(json['unavailable_seat_ids'] ?? []),
    );
  }
  factory SeatMap.empty() {
    return SeatMap(
      unavailableSeatIds: [],
    );
  }
}
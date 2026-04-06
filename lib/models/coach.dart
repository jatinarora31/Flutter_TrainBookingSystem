import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/seat.dart';
part 'coach.g.dart';

@JsonSerializable()
class Coach {
  final String id;
  final String coachNumber;
  final String coachType;
  final int totalSeats;
  final List<Seat> seats;

  Coach({
    required this.id,
    required this.coachNumber,
    required this.coachType,
    required this.totalSeats,
    required this.seats,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      coachNumber: json['coach_number'],
      coachType: json['coach_type'],
      totalSeats: json['total_seats'],
      seats: (json['seats'] as List).map((s) => Seat.fromJson(s)).toList(),
    );
  }

  String get displayType {
    switch (coachType) {
      case 'one_ac':
        return '1A';
      case 'two_ac':
        return '2A';
      case 'sleeper':
        return 'SL';
      default:
        return coachType.toUpperCase();
    }
  }
}